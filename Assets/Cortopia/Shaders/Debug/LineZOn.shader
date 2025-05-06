Shader "Debug/LineZOn" {
        SubShader {
                Pass {
                        Blend SrcAlpha OneMinusSrcAlpha
                        ZWrite On
                        Cull Off
                        BindChannels {
                                Bind "vertex", vertex
                                Bind "color", color
                        }
                }
        }
}