/*
 * Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.
 */

package com.voximplant.voximplant_kit_chat

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.UiThread
import com.voximplant.android.kit.chat.core.exceptions.KitConnectionRequiredException
import com.voximplant.android.kit.chat.core.exceptions.KitInternalException
import com.voximplant.android.kit.chat.core.exceptions.KitTimeoutException
import com.voximplant.android.kit.chat.ui.KitChatUi
import com.voximplant.android.kit.chat.ui.model.AuthorizationError
import com.voximplant.android.kit.chat.ui.model.ClientData
import com.voximplant.android.kit.chat.ui.model.Region
import io.flutter.embedding.engine.plugins.FlutterPlugin
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

/** VoximplantKitChatPlugin */
class VoximplantKitChatPlugin : FlutterPlugin, VoximplantKitChatApi {
    private var applicationContext: Context? = null
    private var kitChatUi: KitChatUi? = null
    private var flutterApi: VoximplantKitChatFlutterApi? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private val coroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        flutterApi = VoximplantKitChatFlutterApi(flutterPluginBinding.binaryMessenger)
        VoximplantKitChatApi.setUp(flutterPluginBinding.binaryMessenger, this)
    }

    override fun initialize(credentials: KitChatCredentials) {
        kitChatUi = KitChatUi(
            context = applicationContext ?: throw FlutterError(
                code = "INITIALIZATION_FAILED",
                message = "Android context is not attached",
            ),
            accountRegion = credentials.region.toRegion(),
            channelUuid = credentials.channelUuid,
            token = credentials.token,
            clientId = credentials.clientId
        ).apply {
            onAuthorizationError = { error ->
                Log.e(TAG, "KitChat authorization error: $error")
                mainHandler.post {
                    flutterApi?.onAuthorizationError(error.toKitChatAuthorizationError()) { result ->
                        result.exceptionOrNull()?.let { callbackError ->
                            Log.e(TAG, "Failed to send auth error to Flutter: $callbackError")
                        }
                    }
                }
            }
        }
    }

    override fun applyCustomization(customization: KitChatCustomization) {
        customization.colorScheme?.let { colorScheme ->
            KitChatUi.colorScheme = colorScheme.toKitChatColorScheme()
        }
    }

    @UiThread
    override fun openChat() {
        kitChatUi?.startActivity() ?: throw FlutterError(
            code = "NOT_INITIALIZED",
            message = "KitChatUi is not initialized",
        )
    }

    /** Android does not track whether the chat is currently open. */
    override fun isChatVisible(): Boolean = false

    override fun setClientData(data: KitChatClientData, callback: (Result<Unit>) -> Unit) {
        val currentKitChatUi = kitChatUi
        if (currentKitChatUi == null) {
            callback(Result.failure(FlutterError("NOT_INITIALIZED", "KitChatUi is not initialized")))
            return
        }

        val clientData = ClientData(
            displayName = data.displayName,
            avatarUrl = data.avatarUrl,
            email = data.email,
            phone = data.phone,
            language = data.language
        )
        coroutineScope.launch {
            currentKitChatUi.setClientData(clientData).onSuccess {
                callback(Result.success(Unit))
            }.onFailure { exception ->
                val code = when (exception) {
                    is IllegalArgumentException -> "ILLEGAL_ARGUMENT"
                    is KitConnectionRequiredException -> "CONNECTION_REQUIRED"
                    is KitTimeoutException -> "TIMEOUT"
                    is KitInternalException -> "INTERNAL"
                    else -> "UNKNOWN"
                }
                callback(Result.failure(FlutterError(code, exception.message)))
            }
        }
    }

    override fun registerPushToken(token: String, callback: (Result<Unit>) -> Unit) {
        val currentKitChatUi = kitChatUi
        if (currentKitChatUi == null) {
            callback(Result.failure(FlutterError("NOT_INITIALIZED", "KitChatUi is not initialized")))
            return
        }

        coroutineScope.launch {
            currentKitChatUi.registerPushToken(token).onSuccess {
                callback(Result.success(Unit))
            }.onFailure { exception ->
                val code = when (exception) {
                    is IllegalArgumentException -> "ILLEGAL_ARGUMENT"
                    is KitConnectionRequiredException -> "CONNECTION_REQUIRED"
                    is KitTimeoutException -> "TIMEOUT"
                    is KitInternalException -> "INTERNAL"
                    else -> "UNKNOWN"
                }
                callback(Result.failure(FlutterError(code, exception.message)))
            }
        }
    }

    override fun unregisterPushToken(token: String, callback: (Result<Unit>) -> Unit) {
        val currentKitChatUi = kitChatUi
        if (currentKitChatUi == null) {
            callback(Result.failure(FlutterError("NOT_INITIALIZED", "KitChatUi is not initialized")))
            return
        }

        coroutineScope.launch {
            currentKitChatUi.unregisterPushToken(token).onSuccess {
                callback(Result.success(Unit))
            }.onFailure { exception ->
                val code = when (exception) {
                    is IllegalArgumentException -> "ILLEGAL_ARGUMENT"
                    is KitConnectionRequiredException -> "CONNECTION_REQUIRED"
                    is KitTimeoutException -> "TIMEOUT"
                    is KitInternalException -> "INTERNAL"
                    else -> "UNKNOWN"
                }
                callback(Result.failure(FlutterError(code, exception.message)))
            }
        }
    }

    override fun handlePush(payload: Map<String, String>, callback: (Result<Unit>) -> Unit) {
        val currentKitChatUi = kitChatUi
        if (currentKitChatUi == null) {
            callback(Result.failure(FlutterError("NOT_INITIALIZED", "KitChatUi is not initialized")))
            return
        }

        try {
            currentKitChatUi.handlePush(payload)
            callback(Result.success(Unit))
        } catch (exception: Exception) {
            callback(Result.failure(FlutterError("HANDLE_PUSH_FAILED", exception.message)))
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        VoximplantKitChatApi.setUp(binding.binaryMessenger, null)
        coroutineScope.cancel()
        applicationContext = null
        kitChatUi = null
        flutterApi = null
    }

    private fun KitChatRegion.toRegion(): Region = when (this) {
        KitChatRegion.RU -> Region.RU
        KitChatRegion.RU2 -> Region.RU_2
        KitChatRegion.EU -> Region.EU
        KitChatRegion.US -> Region.US
        KitChatRegion.BR -> Region.BR
        KitChatRegion.KZ -> Region.KZ
    }

    private fun AuthorizationError.toKitChatAuthorizationError(): KitChatAuthorizationError = when (this) {
        is AuthorizationError.InvalidChannelUuid -> KitChatAuthorizationError.INVALID_CHANNEL_UUID
        is AuthorizationError.InvalidToken -> KitChatAuthorizationError.INVALID_TOKEN
        is AuthorizationError.InvalidClientId -> KitChatAuthorizationError.INVALID_CLIENT_ID
        else -> KitChatAuthorizationError.UNKNOWN
    }

    private companion object {
        const val TAG = "VoximplantKitChat"
    }
}
