// HeightColorGradient by Mark Johns - @Doomlaser - https://twitter.com/Doomlaser
// Set two colors to blend, min and max distance define the bottom and top Y values between which the colors will blend
Shader "Custom/HeightColorGradientNoLighting" {
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MaxColor ("Color in Maxmal", Color) = (0, 0, 0, 0)
        _MinDistance ("Min Distance", Float) = 100
        _MaxDistance ("Max Distance", Float) = 1000
    }
    SubShader {
        Tags { "RenderType"="Opaque" }

        
        Zwrite On
       
        CGPROGRAM
         
        #pragma surface surf NoLighting
 
        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
            float3 screenPos;
            float4 color : COLOR;
        };
 
        float _MaxDistance;
        float _MinDistance;
        float4 _Color;
        float4 _MaxColor;
 
        void surf (Input IN, inout SurfaceOutput o) {
            
            half4 dist = IN.worldPos.y;
            half4 weight =  (dist - _MinDistance) / (_MaxDistance - _MinDistance);
            half4 distanceColor = lerp(_Color, _MaxColor, weight);
 
            o.Albedo = IN.color.rgb * distanceColor.rgb ;

           
           // o.Alpha = IN.color.a * distanceColor.a;           
            o.Alpha = 1;
        }
     fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
         {
             fixed4 c;
             c.rgb = s.Albedo; 
             c.a = s.Alpha;
             return c;
         }    
        ENDCG
    } 
    FallBack "Diffuse"
}
