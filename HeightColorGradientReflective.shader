// HeightColorGradient by Mark Johns - https://twitter.com/Doomlaser
// Set two colors to blend, min and max distance define the bottom and top Y values between which the colors will blend
Shader "Custom/HeightColorGradientReflective" 
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MaxColor ("Color in Maxmal", Color) = (0, 0, 0, 0)
        _MinDistance ("Min Distance", Float) = 100
        _MaxDistance ("Max Distance", Float) = 1000        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
            float3 screenPos; 
            float4 color : COLOR;                       
        };

        half _Glossiness;
        half _Metallic;
        float _MaxDistance;
        float _MinDistance;        
        fixed4 _Color;
        float4 _MaxColor;
 
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
           half4 dist = IN.worldPos.y;
           half4 weight =  (dist - _MinDistance) / (_MaxDistance - _MinDistance);
           half4 distanceColor = lerp(_Color, _MaxColor, weight);

            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = IN.color.rgb * distanceColor.rgb ;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
