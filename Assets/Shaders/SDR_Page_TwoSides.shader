// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Page_TwoSides"
{
	Properties
	{
		_Front("Front", 2D) = "white" {}
		_Back("Back", 2D) = "white" {}
		_Diffuse("Diffuse", Range( 0 , 1)) = 1
		_Emission("Emission", Range( 0 , 3)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		CGPROGRAM
		#pragma target 3.0
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Lambert keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half ASEVFace : VFACE;
			float2 uv_texcoord;
		};

		uniform sampler2D _Front;
		uniform float4 _Front_ST;
		uniform sampler2D _Back;
		uniform float4 _Back_ST;
		uniform half _Diffuse;
		uniform half _Emission;

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 switchResult13 = (((i.ASEVFace>0)?(half3(0,0,1)):(half3(0,0,-1))));
			o.Normal = switchResult13;
			float2 uv_Front = i.uv_texcoord * _Front_ST.xy + _Front_ST.zw;
			float2 uv_Back = i.uv_texcoord * _Back_ST.xy + _Back_ST.zw;
			float4 switchResult1 = (((i.ASEVFace>0)?(tex2D( _Front, uv_Front )):(tex2D( _Back, uv_Back ))));
			o.Albedo = ( switchResult1 * _Diffuse ).rgb;
			o.Emission = ( switchResult1 * _Emission ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16300
2196;91;2034;1261;1820.599;1297.322;1.654659;True;True
Node;AmplifyShaderEditor.SamplerNode;2;-991.7172,-853.9666;Float;True;Property;_Front;Front;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-904.4885,-488.7099;Float;True;Property;_Back;Back;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwitchByFaceNode;1;-67.59958,-558.504;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-61.124,-659.387;Half;False;Property;_Diffuse;Diffuse;2;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-142.0446,-269.5007;Half;False;Property;_Emission;Emission;3;0;Create;True;0;0;False;0;0;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;14;-274.447,-104.73;Half;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;15;-235.447,244.9699;Half;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;False;0;0,0,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwitchByFaceNode;13;-11.84693,-67.02993;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;206.3177,-329.5705;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;274.9582,-543.0012;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;456.7425,-359.6611;Float;False;True;2;Float;ASEMaterialInspector;0;0;Lambert;Custom/Page_TwoSides;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;False;False;False;False;False;False;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;1;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;2;0
WireConnection;1;1;16;0
WireConnection;13;0;14;0
WireConnection;13;1;15;0
WireConnection;17;0;1;0
WireConnection;17;1;18;0
WireConnection;19;0;1;0
WireConnection;19;1;20;0
WireConnection;0;0;19;0
WireConnection;0;1;13;0
WireConnection;0;2;17;0
ASEEND*/
//CHKSM=AFA67CB88FADD7B6B677B82D47931D0577D93B46