/*
 * Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.
 */

package com.voximplant.voximplant_kit_chat

import com.voximplant.android.kit.chat.ui.KitChatColorScheme as KitChatColorSchemeCore

fun KitChatColorScheme.toKitChatColorScheme(): KitChatColorSchemeCore {
    val defaults = KitChatColorSchemeCore()

    val brand = brand?.toInt() ?: defaults.brand
    val brandContainer = brandContainer?.toInt() ?: defaults.brandContainer
    val negative = negative?.toInt() ?: defaults.negative
    val negativeContainer = negativeContainer?.toInt() ?: defaults.negativeContainer
    val notification = notification?.toInt() ?: defaults.notification
    val onBrand = onBrand?.toInt() ?: defaults.onBrand
    val onBrandContainer = onBrandContainer?.toInt() ?: defaults.onBrandContainer
    val positive = positive?.toInt() ?: defaults.positive
    val positiveContainer = positiveContainer?.toInt() ?: defaults.positiveContainer
    val avatarPlaceholder = avatarPlaceholder?.toInt() ?: defaults.avatarPlaceholder

    return KitChatColorSchemeCore(
        brand = brand,
        brandContainer = brandContainer,
        negative = negative,
        negativeContainer = negativeContainer,
        notification = notification,
        onBrand = onBrand,
        onBrandContainer = onBrandContainer,
        positive = positive,
        positiveContainer = positiveContainer,
        avatarPlaceholder = avatarPlaceholder
    )
}
