# Jailbreaking Android

A Jailbreak of Android is called `rooting`.[^1]

In Linux terms (which is what Android runs on), this means you (the owner of the device) can take actions on the device as `root`

Another aim of the `rooting` process is to edit the way Android loads processes at boot and to take control of the `zygote`.[^2]

This allows the root framework (often `Magisk`[^3]) to embed its own logic before any other is run from the manufacturer's image.

Ultimately, this allows the root framework to hide itself from many checks, and have control over every process that the system launches.
This platforms most reasons for `rooting` your Android device, as most of the internal Linux components that are contained in your Android image may be things you want to edit (either in-place, their behavior, or even replace).

A good example, and my main reason consistently for `rooting` my Android is to edit how the audio driver works that runs for sound output with `Viper4Android`.[^4]

[^1]: "Android rooting." Wikipedia, The Free Encyclopedia. https://en.wikipedia.org/wiki/Rooting_(Android)

[^2]: "The Zygote Process." Android Source Documentation. https://source.android.com/docs/core/runtime/zygote

[^3]: Magisk - The Magic Mask for Android. https://github.com/topjohnwu/Magisk

[^4]: ViPER4Android - Audio enhancement software for Android. https://github.com/AndroidAudioMods/ViPER4Android