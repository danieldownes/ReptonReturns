xof 0302txt 0032
Header {
 1;
 0;
 1;
}
template Header {
 <3D82AB43-62DA-11cf-AB39-0020AF71E433>
 WORD major;
 WORD minor;
 DWORD flags;
}

template Vector {
 <3D82AB5E-62DA-11cf-AB39-0020AF71E433>
 FLOAT x;
 FLOAT y;
 FLOAT z;
}

template Coords2d {
 <F6F23F44-7686-11cf-8F52-0040333594A3>
 FLOAT u;
 FLOAT v;
}

template Matrix4x4 {
 <F6F23F45-7686-11cf-8F52-0040333594A3>
 array FLOAT matrix[16];
}

template ColorRGBA {
 <35FF44E0-6C7C-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
 FLOAT alpha;
}

template ColorRGB {
 <D3E16E81-7835-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
}

template TextureFilename {
 <A42790E1-7810-11cf-8F52-0040333594A3>
 STRING filename;
}

template Material {
 <3D82AB4D-62DA-11cf-AB39-0020AF71E433>
 ColorRGBA faceColor;
 FLOAT power;
 ColorRGB specularColor;
 ColorRGB emissiveColor;
 [...]
}

template MeshFace {
 <3D82AB5F-62DA-11cf-AB39-0020AF71E433>
 DWORD nFaceVertexIndices;
 array DWORD faceVertexIndices[nFaceVertexIndices];
}

template MeshTextureCoords {
 <F6F23F40-7686-11cf-8F52-0040333594A3>
 DWORD nTextureCoords;
 array Coords2d textureCoords[nTextureCoords];
}

template MeshMaterialList {
 <F6F23F42-7686-11cf-8F52-0040333594A3>
 DWORD nMaterials;
 DWORD nFaceIndexes;
 array DWORD faceIndexes[nFaceIndexes];
 [Material]
}

template MeshNormals {
 <F6F23F43-7686-11cf-8F52-0040333594A3>
 DWORD nNormals;
 array Vector normals[nNormals];
 DWORD nFaceNormals;
 array MeshFace faceNormals[nFaceNormals];
}

template Mesh {
 <3D82AB44-62DA-11cf-AB39-0020AF71E433>
 DWORD nVertices;
 array Vector vertices[nVertices];
 DWORD nFaces;
 array MeshFace faces[nFaces];
 [...]
}

template FrameTransformMatrix {
 <F6F23F41-7686-11cf-8F52-0040333594A3>
 Matrix4x4 frameMatrix;
}

template Frame {
 <3D82AB46-62DA-11cf-AB39-0020AF71E433>
 [...]
}
template FloatKeys {
 <10DD46A9-775B-11cf-8F52-0040333594A3>
 DWORD nValues;
 array FLOAT values[nValues];
}

template TimedFloatKeys {
 <F406B180-7B3B-11cf-8F52-0040333594A3>
 DWORD time;
 FloatKeys tfkeys;
}

template AnimationKey {
 <10DD46A8-775B-11cf-8F52-0040333594A3>
 DWORD keyType;
 DWORD nKeys;
 array TimedFloatKeys keys[nKeys];
}

template AnimationOptions {
 <E2BF56C0-840F-11cf-8F52-0040333594A3>
 DWORD openclosed;
 DWORD positionquality;
}

template Animation {
 <3D82AB4F-62DA-11cf-AB39-0020AF71E433>
 [...]
}

template AnimationSet {
 <3D82AB50-62DA-11cf-AB39-0020AF71E433>
 [Animation]
}

template XSkinMeshHeader {
 <3cf169ce-ff7c-44ab-93c0-f78f62d172e2>
 WORD nMaxSkinWeightsPerVertex;
 WORD nMaxSkinWeightsPerFace;
 WORD nBones;
}

template VertexDuplicationIndices {
 <b8d65549-d7c9-4995-89cf-53a9a8b031e3>
 DWORD nIndices;
 DWORD nOriginalVertices;
 array DWORD indices[nIndices];
}

template SkinWeights {
 <6f0d123b-bad2-4167-a0d0-80224f25fabb>
 STRING transformNodeName;
 DWORD nWeights;
 array DWORD vertexIndices[nWeights];
 array FLOAT weights[nWeights];
 Matrix4x4 matrixOffset;
}
Frame Cone03 {
   FrameTransformMatrix {
3.136045,0.000000,0.000000,0.000000,
0.000000,3.136045,0.000000,0.000000,
0.000000,0.000000,3.136045,0.000000,
13.913134,-1.844799,-0.016147,1.000000;;
 }
Mesh Cone031 {
 24;
4.327932;1.540899;0.000000;,
0.000000;7.925228;2.885288;,
2.885288;7.925228;0.000000;,
-0.000000;1.540899;4.327932;,
-0.000000;1.540899;4.327932;,
-2.885288;7.925228;0.000000;,
0.000000;7.925228;2.885288;,
-0.000000;1.540899;4.327932;,
-4.327932;1.540899;-0.000000;,
0.000000;7.925228;-2.885288;,
0.000001;1.540899;-4.327932;,
0.000000;20.287205;2.139028;,
2.139027;20.287205;0.000001;,
0.000000;7.925228;2.885288;,
-2.139027;20.287205;0.000000;,
0.000000;20.287205;2.139028;,
0.000000;7.925228;2.885288;,
0.000000;20.287205;-2.139026;,
0.000000;53.492195;0.000000;,
0.000000;53.492195;0.000000;,
0.000000;53.492195;0.000000;,
0.000000;20.287205;2.139028;,
0.000000;53.492195;0.000000;,
0.000000;53.492195;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,8,7;,
3;5,9,8;,
3;9,10,8;,
3;9,2,10;,
3;2,0,10;,
3;12,11,2;,
3;11,1,2;,
3;15,14,13;,
3;14,5,16;,
3;14,17,5;,
3;17,9,5;,
3;17,12,9;,
3;12,2,9;,
3;19,18,12;,
3;18,11,12;,
3;18,20,11;,
3;20,14,21;,
3;20,22,14;,
3;22,17,14;,
3;22,19,17;,
3;19,12,17;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;;
MeshMaterialList {
 1;
 28;
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0;;
Material {
 0.968628;0.964706;0.960784;1.000000;;
11.313708;
 0.898039;0.898039;0.898039;;
 0.501961;0.501961;0.501961;;
 }
}

 MeshNormals {
 24;
0.927609;0.209608;0.309203;,
0.702033;0.119581;0.702033;,
0.989972;0.141252;0.001930;,
0.698250;0.157781;0.698250;,
-0.698250;0.157781;0.698250;,
-0.989972;0.141252;-0.001930;,
-0.698250;0.157781;0.698250;,
-0.698250;0.157781;0.698250;,
-0.927609;0.209608;-0.309203;,
0.001930;0.141252;-0.989972;,
0.309203;0.209608;-0.927609;,
0.661585;0.353003;0.661585;,
0.928837;0.320544;-0.185777;,
-0.706464;0.042647;0.706463;,
-0.928837;0.320544;0.185777;,
-0.706464;0.042647;0.706463;,
-0.706464;0.042647;0.706463;,
-0.185777;0.320544;-0.928837;,
0.310303;0.898568;0.310303;,
0.310303;0.898568;-0.310303;,
-0.310303;0.898568;0.310303;,
-0.706374;0.045504;0.706374;,
-0.310303;0.898568;-0.310303;,
0.000000;1.000000;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,8,7;,
3;5,9,8;,
3;9,10,8;,
3;9,2,10;,
3;2,0,10;,
3;12,11,2;,
3;11,1,2;,
3;15,14,13;,
3;14,5,16;,
3;14,17,5;,
3;17,9,5;,
3;17,12,9;,
3;12,2,9;,
3;19,18,12;,
3;18,11,12;,
3;18,20,11;,
3;20,14,21;,
3;20,22,14;,
3;22,17,14;,
3;22,19,17;,
3;19,12,17;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;;
 }
MeshTextureCoords {
 24;
0.750000;0.973628;,
1.000000;0.866434;,
0.750000;0.866434;,
1.000000;0.973628;,
-0.000000;0.973628;,
0.250000;0.866434;,
-0.000000;0.866434;,
-0.000000;0.973628;,
0.250000;0.973628;,
0.500000;0.866434;,
0.500000;0.973628;,
1.000000;0.658873;,
0.750000;0.658873;,
-0.000000;0.866434;,
0.250000;0.658873;,
-0.000000;0.658873;,
-0.000000;0.866434;,
0.500000;0.658873;,
0.500000;0.101353;,
0.500000;0.101353;,
0.500000;0.101353;,
-0.000000;0.658873;,
0.500000;0.101353;,
0.500000;0.101353;;
}
}
 }
Frame Cone05 {
   FrameTransformMatrix {
2.542572,0.000000,-0.864881,0.000000,
0.000000,2.685646,0.000000,0.000000,
0.864881,0.000000,2.542572,0.000000,
-39.929382,-1.844799,22.151640,1.000000;;
 }
Mesh Cone051 {
 23;
6.417080;0.000000;0.000000;,
-0.000000;9.466127;4.278055;,
4.278054;9.466127;0.000000;,
-0.000001;0.000000;6.417081;,
-0.000001;0.000000;6.417081;,
-4.278054;9.466127;-0.000000;,
-0.000000;9.466127;4.278055;,
-6.417080;0.000000;-0.000000;,
0.000000;9.466127;-4.278053;,
0.000001;0.000000;-6.417081;,
0.000000;26.293890;2.139028;,
2.139026;26.293890;0.000001;,
-0.000000;9.466127;4.278055;,
-2.139027;26.293890;0.000001;,
0.000000;26.293890;2.139028;,
-0.000000;9.466127;4.278055;,
0.000001;26.293890;-2.139026;,
0.000000;59.498878;0.000000;,
0.000000;59.498878;0.000000;,
0.000000;59.498878;0.000000;,
0.000000;26.293890;2.139028;,
0.000000;59.498878;0.000000;,
0.000000;59.498878;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,7,4;,
3;5,8,7;,
3;8,9,7;,
3;8,2,9;,
3;2,0,9;,
3;11,10,2;,
3;10,1,2;,
3;14,13,12;,
3;13,5,15;,
3;13,16,5;,
3;16,8,5;,
3;16,11,8;,
3;11,2,8;,
3;18,17,11;,
3;17,10,11;,
3;17,19,10;,
3;19,13,20;,
3;19,21,13;,
3;21,16,13;,
3;21,18,16;,
3;18,11,16;,
3;22,22,22;,
3;22,22,22;,
3;22,22,22;,
3;22,22,22;;
MeshMaterialList {
 1;
 28;
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0;;
Material {
 0.968628;0.964706;0.960784;1.000000;;
11.313708;
 0.898039;0.898039;0.898039;;
 0.501961;0.501961;0.501961;;
 }
}

 MeshNormals {
 23;
0.927609;0.209608;0.309203;,
0.700624;0.135099;0.700624;,
0.984807;0.173649;0.001408;,
0.698250;0.157781;0.698250;,
-0.698250;0.157781;0.698250;,
-0.984807;0.173649;-0.001409;,
-0.698250;0.157781;0.698250;,
-0.927609;0.209608;-0.309203;,
0.001409;0.173649;-0.984807;,
0.309203;0.209608;-0.927609;,
0.654385;0.378893;0.654385;,
0.917231;0.353715;-0.183227;,
-0.704268;0.089522;0.704268;,
-0.917231;0.353715;0.183227;,
-0.704268;0.089522;0.704268;,
-0.704268;0.089522;0.704268;,
-0.183227;0.353716;-0.917231;,
0.310303;0.898568;0.310303;,
0.310303;0.898568;-0.310303;,
-0.310303;0.898568;0.310303;,
-0.706374;0.045504;0.706374;,
-0.310303;0.898568;-0.310303;,
0.000000;1.000000;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,7,4;,
3;5,8,7;,
3;8,9,7;,
3;8,2,9;,
3;2,0,9;,
3;11,10,2;,
3;10,1,2;,
3;14,13,12;,
3;13,5,15;,
3;13,16,5;,
3;16,8,5;,
3;16,11,8;,
3;11,2,8;,
3;18,17,11;,
3;17,10,11;,
3;17,19,10;,
3;19,13,20;,
3;19,21,13;,
3;21,16,13;,
3;21,18,16;,
3;18,11,16;,
3;22,22,22;,
3;22,22,22;,
3;22,22,22;,
3;22,22,22;;
 }
MeshTextureCoords {
 23;
0.750000;0.999501;,
1.000000;0.840562;,
0.750000;0.840562;,
1.000000;0.999501;,
-0.000000;0.999501;,
0.250000;0.840562;,
-0.000000;0.840562;,
0.250000;0.999501;,
0.500000;0.840562;,
0.500000;0.999501;,
1.000000;0.558020;,
0.750000;0.558020;,
-0.000000;0.840562;,
0.250000;0.558020;,
-0.000000;0.558020;,
-0.000000;0.840562;,
0.500000;0.558020;,
0.500000;0.000499;,
0.500000;0.000499;,
0.500000;0.000499;,
-0.000000;0.558020;,
0.500000;0.000499;,
0.500000;0.000499;;
}
}
 }
Frame Cone08 {
   FrameTransformMatrix {
1.743377,0.000000,2.333949,0.000000,
0.000000,2.913191,0.000000,0.000000,
-2.333949,0.000000,1.743377,0.000000,
32.719986,0.274415,-27.927794,1.000000;;
 }
Mesh Cone081 {
 24;
6.417081;0.000000;-0.000000;,
-0.000000;9.466127;4.278054;,
4.278054;9.466127;0.000001;,
-0.000000;0.000000;6.417080;,
-0.000000;0.000000;6.417080;,
-4.278054;9.466127;0.000000;,
-0.000000;9.466127;4.278054;,
-0.000000;0.000000;6.417080;,
-6.417081;0.000000;-0.000001;,
0.000001;9.466127;-4.278053;,
0.000000;0.000000;-6.417080;,
-0.000000;26.293892;2.139028;,
2.139027;26.293892;0.000000;,
-0.000000;9.466127;4.278054;,
-2.139027;26.293892;0.000000;,
-0.000000;26.293892;2.139028;,
-0.000000;9.466127;4.278054;,
0.000001;26.293892;-2.139026;,
0.000000;59.498882;0.000000;,
0.000000;59.498882;0.000000;,
0.000000;59.498882;0.000000;,
-0.000000;26.293892;2.139028;,
0.000000;59.498882;0.000000;,
0.000000;59.498882;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,8,7;,
3;5,9,8;,
3;9,10,8;,
3;9,2,10;,
3;2,0,10;,
3;12,11,2;,
3;11,1,2;,
3;15,14,13;,
3;14,5,16;,
3;14,17,5;,
3;17,9,5;,
3;17,12,9;,
3;12,2,9;,
3;19,18,12;,
3;18,11,12;,
3;18,20,11;,
3;20,14,21;,
3;20,22,14;,
3;22,17,14;,
3;22,19,17;,
3;19,12,17;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;;
MeshMaterialList {
 1;
 28;
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0;;
Material {
 0.968628;0.964706;0.960784;1.000000;;
11.313708;
 0.898039;0.898039;0.898039;;
 0.501961;0.501961;0.501961;;
 }
}

 MeshNormals {
 24;
0.927609;0.209608;0.309203;,
0.700624;0.135099;0.700624;,
0.984807;0.173649;0.001409;,
0.698250;0.157781;0.698250;,
-0.698250;0.157781;0.698250;,
-0.984807;0.173649;-0.001409;,
-0.698250;0.157781;0.698250;,
-0.698250;0.157781;0.698250;,
-0.927609;0.209609;-0.309203;,
0.001409;0.173649;-0.984807;,
0.309203;0.209608;-0.927609;,
0.654385;0.378893;0.654385;,
0.917231;0.353715;-0.183227;,
-0.704268;0.089522;0.704268;,
-0.917231;0.353716;0.183227;,
-0.704268;0.089522;0.704268;,
-0.704268;0.089522;0.704268;,
-0.183227;0.353715;-0.917231;,
0.310303;0.898568;0.310303;,
0.310303;0.898568;-0.310303;,
-0.310303;0.898568;0.310303;,
-0.706374;0.045504;0.706374;,
-0.310303;0.898568;-0.310303;,
0.000000;1.000000;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,8,7;,
3;5,9,8;,
3;9,10,8;,
3;9,2,10;,
3;2,0,10;,
3;12,11,2;,
3;11,1,2;,
3;15,14,13;,
3;14,5,16;,
3;14,17,5;,
3;17,9,5;,
3;17,12,9;,
3;12,2,9;,
3;19,18,12;,
3;18,11,12;,
3;18,20,11;,
3;20,14,21;,
3;20,22,14;,
3;22,17,14;,
3;22,19,17;,
3;19,12,17;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;;
 }
MeshTextureCoords {
 24;
0.750000;0.999501;,
1.000000;0.840562;,
0.750000;0.840562;,
1.000000;0.999501;,
-0.000000;0.999501;,
0.250000;0.840562;,
-0.000000;0.840562;,
-0.000000;0.999501;,
0.250000;0.999501;,
0.500000;0.840562;,
0.500000;0.999501;,
1.000000;0.558020;,
0.750000;0.558020;,
-0.000000;0.840562;,
0.250000;0.558020;,
-0.000000;0.558020;,
-0.000000;0.840562;,
0.500000;0.558020;,
0.500000;0.000499;,
0.500000;0.000499;,
0.500000;0.000499;,
-0.000000;0.558020;,
0.500000;0.000499;,
0.500000;0.000499;;
}
}
 }
Frame Cone09 {
   FrameTransformMatrix {
0.957714,0.000000,-2.370838,0.000000,
0.000000,2.556969,0.000000,0.000000,
2.370838,0.000000,0.957714,0.000000,
-7.341108,-1.844799,21.585331,1.000000;;
 }
Mesh Cone091 {
 24;
6.417081;0.000000;0.000000;,
-0.000000;7.047562;4.278054;,
4.278053;7.047562;0.000000;,
-0.000000;-2.418566;6.417080;,
-0.000000;-2.418566;6.417080;,
-4.278053;7.047562;0.000000;,
-0.000000;7.047562;4.278054;,
-0.000000;-2.418566;6.417080;,
-6.417081;0.000000;-0.000000;,
0.000001;7.047562;-4.278053;,
0.000001;0.000000;-6.417081;,
-0.000000;23.875326;2.139027;,
2.139027;23.875326;0.000000;,
-0.000000;7.047562;4.278054;,
-2.139026;23.875326;0.000000;,
-0.000000;23.875326;2.139027;,
-0.000000;7.047562;4.278054;,
0.000000;23.875326;-2.139026;,
0.000000;45.345654;0.000000;,
0.000000;45.345654;0.000000;,
0.000000;45.345654;0.000000;,
-0.000000;23.875326;2.139027;,
0.000000;45.345654;0.000000;,
0.000000;45.345654;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,8,7;,
3;5,9,8;,
3;9,10,8;,
3;9,2,10;,
3;2,0,10;,
3;12,11,2;,
3;11,1,2;,
3;15,14,13;,
3;14,5,16;,
3;14,17,5;,
3;17,9,5;,
3;17,12,9;,
3;12,2,9;,
3;19,18,12;,
3;18,11,12;,
3;18,20,11;,
3;20,14,21;,
3;20,22,14;,
3;22,17,14;,
3;22,19,17;,
3;19,12,17;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;;
MeshMaterialList {
 1;
 28;
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0;;
Material {
 0.968628;0.964706;0.960784;1.000000;;
11.313708;
 0.898039;0.898039;0.898039;;
 0.501961;0.501961;0.501961;;
 }
}

 MeshNormals {
 24;
0.910022;0.259489;0.323304;,
0.688157;0.154833;0.708849;,
0.977755;0.209726;0.003013;,
0.665799;0.164454;0.727782;,
-0.698250;0.157781;0.698250;,
-0.980396;0.196894;0.007560;,
-0.698250;0.157781;0.698250;,
-0.654561;0.198668;0.729438;,
-0.914799;0.277654;-0.293345;,
0.003014;0.209726;-0.977755;,
0.303882;0.276696;-0.911644;,
0.652428;0.385586;0.652428;,
0.912915;0.365089;-0.182470;,
-0.704268;0.089522;0.704268;,
-0.912915;0.365089;0.182470;,
-0.704268;0.089522;0.704268;,
-0.704268;0.089522;0.704268;,
-0.182470;0.365089;-0.912915;,
0.306936;0.900878;0.306936;,
0.306936;0.900878;-0.306936;,
-0.306936;0.900878;0.306936;,
-0.705359;0.070273;0.705359;,
-0.306936;0.900878;-0.306936;,
0.000000;1.000000;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,8,7;,
3;5,9,8;,
3;9,10,8;,
3;9,2,10;,
3;2,0,10;,
3;12,11,2;,
3;11,1,2;,
3;15,14,13;,
3;14,5,16;,
3;14,17,5;,
3;17,9,5;,
3;17,12,9;,
3;12,2,9;,
3;19,18,12;,
3;18,11,12;,
3;18,20,11;,
3;20,14,21;,
3;20,22,14;,
3;22,17,14;,
3;22,19,17;,
3;19,12,17;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;;
 }
MeshTextureCoords {
 24;
0.750000;0.999501;,
1.000000;0.881170;,
0.750000;0.881170;,
1.000000;1.040109;,
-0.000000;1.040109;,
0.250000;0.881170;,
-0.000000;0.881170;,
-0.000000;1.040109;,
0.250000;0.999501;,
0.500000;0.881170;,
0.500000;0.999501;,
1.000000;0.598628;,
0.750000;0.598628;,
-0.000000;0.881170;,
0.250000;0.598628;,
-0.000000;0.598628;,
-0.000000;0.881170;,
0.500000;0.598628;,
0.500000;0.238136;,
0.500000;0.238136;,
0.500000;0.238136;,
-0.000000;0.598628;,
0.500000;0.238136;,
0.500000;0.238136;;
}
}
 }
Frame Cone11 {
   FrameTransformMatrix {
2.916210,0.000000,0.179266,0.000000,
0.000000,2.921715,0.000000,0.000000,
-0.179266,0.000000,2.916210,0.000000,
-6.399988,1.526117,-30.797209,1.000000;;
 }
Mesh Cone111 {
 25;
6.417081;0.000000;0.000000;,
-1.281264;9.466127;3.990115;,
4.415826;9.466127;1.953781;,
-2.196453;0.000000;5.923471;,
-3.317599;9.466127;-1.706975;,
-6.417081;0.000000;-0.000001;,
2.379491;9.466127;-3.743310;,
0.000001;0.000000;-6.417081;,
4.415826;9.466127;1.953781;,
6.417081;0.000000;0.000000;,
4.415826;9.466127;1.953781;,
4.415826;9.466127;1.953781;,
1.707220;26.293894;1.288736;,
1.288735;26.293894;-1.707219;,
1.707220;26.293894;1.288736;,
-1.288735;26.293894;1.707220;,
1.707220;26.293894;1.288736;,
-1.707219;26.293894;-1.288735;,
4.415826;9.466127;1.953781;,
0.000000;55.028316;0.000000;,
0.000000;55.028316;0.000000;,
0.000000;55.028316;0.000000;,
1.707220;26.293894;1.288736;,
0.000000;55.028316;0.000000;,
0.000000;55.028316;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;1,4,3;,
3;4,5,3;,
3;4,6,5;,
3;6,7,5;,
3;6,8,7;,
3;10,9,7;,
3;13,12,11;,
3;14,1,2;,
3;16,15,1;,
3;15,4,1;,
3;15,17,4;,
3;17,6,4;,
3;17,13,6;,
3;13,18,6;,
3;20,19,13;,
3;19,12,13;,
3;19,21,12;,
3;21,15,22;,
3;21,23,15;,
3;23,17,15;,
3;23,20,17;,
3;20,13,17;,
3;24,24,24;,
3;24,24,24;,
3;24,24,24;,
3;24,24,24;;
MeshMaterialList {
 1;
 28;
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0;;
Material {
 0.968628;0.964706;0.960784;1.000000;;
11.313708;
 0.898039;0.898039;0.898039;;
 0.501961;0.501961;0.501961;;
 }
}

 MeshNormals {
 25;
0.455486;-0.004820;0.890230;,
-0.114167;0.095153;0.988894;,
0.336538;-0.015721;0.941539;,
-0.530858;0.290548;0.796098;,
-0.981840;0.145950;-0.121193;,
-0.818290;0.298198;-0.491405;,
0.094021;0.099288;-0.990607;,
0.477738;0.249833;-0.842229;,
0.932350;-0.140234;-0.333254;,
0.678131;0.283330;-0.678131;,
0.678131;0.283330;-0.678131;,
0.978854;0.152153;-0.136729;,
0.846882;0.518456;-0.118295;,
0.662637;0.370182;-0.651058;,
0.335183;0.091012;0.937747;,
-0.670029;0.348752;0.655311;,
0.137107;0.133221;0.981557;,
-0.657007;0.345852;-0.669872;,
0.936817;0.101239;-0.334850;,
0.433285;0.899223;-0.060523;,
-0.060523;0.899223;-0.433285;,
0.060523;0.899223;0.433285;,
0.138149;0.052565;0.989016;,
-0.433285;0.899223;0.060523;,
0.000000;1.000000;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;1,4,3;,
3;4,5,3;,
3;4,6,5;,
3;6,7,5;,
3;6,8,7;,
3;10,9,7;,
3;13,12,11;,
3;14,1,2;,
3;16,15,1;,
3;15,4,1;,
3;15,17,4;,
3;17,6,4;,
3;17,13,6;,
3;13,18,6;,
3;20,19,13;,
3;19,12,13;,
3;19,21,12;,
3;21,15,22;,
3;21,23,15;,
3;23,17,15;,
3;23,20,17;,
3;20,13,17;,
3;24,24,24;,
3;24,24,24;,
3;24,24,24;,
3;24,24,24;;
 }
MeshTextureCoords {
 25;
-0.250000;0.999501;,
0.049451;0.840562;,
-0.183703;0.840562;,
0.056514;0.999501;,
0.325630;0.840562;,
0.250000;0.999501;,
0.590119;0.840562;,
0.500000;0.999501;,
0.816297;0.840562;,
0.750000;0.999501;,
0.816297;0.840562;,
0.816297;0.840562;,
0.852912;0.558020;,
0.602912;0.558020;,
-0.147088;0.558020;,
0.102912;0.558020;,
-0.147088;0.558020;,
0.352912;0.558020;,
0.816297;0.840562;,
0.500000;0.075561;,
0.500000;0.075561;,
0.500000;0.075561;,
-0.147088;0.558020;,
0.500000;0.075561;,
0.500000;0.075561;;
}
}
 }
Frame Cone12 {
   FrameTransformMatrix {
1.792783,0.000000,1.218216,0.000000,
0.000000,2.167515,0.000000,0.000000,
-1.218216,0.000000,1.792783,0.000000,
-36.552959,1.639318,-35.260818,1.000000;;
 }
Mesh Cone121 {
 24;
8.234483;-1.340466;-0.000000;,
0.000001;10.806594;5.489656;,
5.489655;10.806594;0.000000;,
0.000000;-1.340466;8.234483;,
0.000000;-1.340466;8.234483;,
-5.489655;10.806594;0.000000;,
0.000001;10.806594;5.489656;,
0.000000;-1.340466;8.234483;,
-8.234484;-1.340466;-0.000001;,
0.000001;10.806594;-5.489654;,
0.000001;-1.340466;-8.234483;,
1.651568;26.293892;2.643060;,
2.643059;26.293892;-1.651565;,
0.000001;10.806594;5.489656;,
-2.643058;26.293892;1.651567;,
1.651568;26.293892;2.643060;,
0.000001;10.806594;5.489656;,
-1.651564;26.293892;-2.643058;,
0.000000;53.340542;0.000000;,
0.000000;53.340542;0.000000;,
0.000000;53.340542;0.000000;,
1.651568;26.293892;2.643060;,
0.000000;53.340542;0.000000;,
0.000000;53.340542;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,8,7;,
3;5,9,8;,
3;9,10,8;,
3;9,2,10;,
3;2,0,10;,
3;12,11,2;,
3;11,1,2;,
3;15,14,13;,
3;14,5,16;,
3;14,17,5;,
3;17,9,5;,
3;17,12,9;,
3;12,2,9;,
3;19,18,12;,
3;18,11,12;,
3;18,20,11;,
3;20,14,21;,
3;20,22,14;,
3;22,17,14;,
3;22,19,17;,
3;19,12,17;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;;
MeshMaterialList {
 1;
 28;
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0;;
Material {
 0.968628;0.964706;0.960784;1.000000;;
11.313708;
 0.898039;0.898039;0.898039;;
 0.501961;0.501961;0.501961;;
 }
}

 MeshNormals {
 24;
0.927609;0.209608;0.309203;,
0.701694;0.123496;0.701694;,
0.979577;0.171539;-0.104901;,
0.698250;0.157781;0.698250;,
-0.698250;0.157781;0.698250;,
-0.979576;0.171540;0.104901;,
-0.698250;0.157781;0.698250;,
-0.698250;0.157781;0.698250;,
-0.927609;0.209609;-0.309203;,
-0.104901;0.171540;-0.979577;,
0.309203;0.209609;-0.927609;,
0.830949;0.421368;0.363280;,
0.749329;0.393312;-0.532739;,
-0.220451;0.199018;0.954879;,
-0.749329;0.393312;0.532739;,
-0.220451;0.199018;0.954879;,
-0.706057;0.054481;0.706057;,
-0.532739;0.393312;-0.749329;,
0.420856;0.901909;0.097162;,
0.097162;0.901909;-0.420856;,
-0.097162;0.901909;0.420856;,
-0.224208;0.081212;0.971152;,
-0.420856;0.901909;-0.097162;,
0.000000;1.000000;0.000000;;

 28;
3;2,1,0;,
3;1,3,0;,
3;6,5,4;,
3;5,8,7;,
3;5,9,8;,
3;9,10,8;,
3;9,2,10;,
3;2,0,10;,
3;12,11,2;,
3;11,1,2;,
3;15,14,13;,
3;14,5,16;,
3;14,17,5;,
3;17,9,5;,
3;17,12,9;,
3;12,2,9;,
3;19,18,12;,
3;18,11,12;,
3;18,20,11;,
3;20,14,21;,
3;20,22,14;,
3;22,17,14;,
3;22,19,17;,
3;19,12,17;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;,
3;23,23,23;;
 }
MeshTextureCoords {
 24;
0.750000;0.953919;,
1.000000;0.776570;,
0.750000;0.776570;,
1.000000;0.953919;,
-0.000000;0.953919;,
0.250000;0.776570;,
-0.000000;0.776570;,
-0.000000;0.953919;,
0.250000;0.953919;,
0.500000;0.776570;,
0.500000;0.953919;,
0.908166;0.550452;,
0.664004;0.550452;,
-0.000000;0.776570;,
0.164004;0.550452;,
-0.091834;0.550452;,
-0.000000;0.776570;,
0.408166;0.550452;,
0.500000;0.155565;,
0.500000;0.155565;,
0.500000;0.155565;,
-0.091834;0.550452;,
0.500000;0.155565;,
0.500000;0.155565;;
}
}
 }