package com.example.fair_share

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.os.Build
import android.provider.Settings
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import android.app.usage.NetworkStatsManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UsageStatsChannel(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "com.fairshare/usage_stats"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "isUsageAccessGranted" -> {
                    result.success(isUsageAccessGranted())
                }
                "openUsageAccessSettings" -> {
                    val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context.startActivity(intent)
                    result.success(true)
                }
                "getMobileUsageBytes" -> {
                    val start = call.argument<Long>("start")
                        ?: return result.error("ARG", "start missing", null)
                    val end = call.argument<Long>("end")
                        ?: return result.error("ARG", "end missing", null)
                    val bytes = getMobileUsageBytes(start, end)
                    result.success(bytes)
                }
                else -> result.notImplemented()
            }
        } catch (e: SecurityException) {
            result.error("SECURITY", e.message, null)
        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }

    private fun isUsageAccessGranted(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                context.packageName
            )
        } else {
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                context.packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun getMobileUsageBytes(start: Long, end: Long): Long {
        val nsm = context.getSystemService(Context.NETWORK_STATS_SERVICE) as NetworkStatsManager
        val (subscriberId, subId) = resolveSubscriberId()

        if (subscriberId == null && subId == null) {
            throw SecurityException(
                "No subscriber info. Ensure READ_PHONE_STATE is granted and there is an active SIM."
            )
        }

        val bucket = nsm.querySummaryForDevice(
            ConnectivityManager.TYPE_MOBILE,
            subscriberId,
            start,
            end
        )
        return bucket.rxBytes + bucket.txBytes
    }

    private fun resolveSubscriberId(): Pair<String?, Int?> {
        val tm = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            val sm = context.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager

            val subIds: IntArray? = when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.N -> {
                    // Use reflection so it compiles even if the symbol isn't in the stubs
                    try {
                        val method = SubscriptionManager::class.java.getMethod("getActiveSubscriptionIdList")
                        @Suppress("UNCHECKED_CAST")
                        method.invoke(sm) as? IntArray
                    } catch (_: Exception) {
                        null
                    }
                }
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
                    intArrayOf(SubscriptionManager.getDefaultSubscriptionId())
                }
                else -> null
            }

            if (subIds != null && subIds.isNotEmpty()) {
                val subId = subIds[0]
                val tmForSub = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    tm.createForSubscriptionId(subId)
                } else tm
                val sid = try {
                    tmForSub.subscriberId
                } catch (_: SecurityException) {
                    null
                }
                return Pair(sid, subId)
            }
        }

        val sid = try {
            tm.subscriberId
        } catch (_: SecurityException) {
            null
        }
        return Pair(sid, null)
    }
}
