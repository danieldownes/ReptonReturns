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
Frame GeoSphere0 {
   FrameTransformMatrix {
1.212850,0.000000,0.000000,0.000000,
0.000000,1.212850,0.000000,0.000000,
0.000000,0.000000,1.212850,0.000000,
0.068781,-0.278172,0.000000,1.000000;;
 }
Mesh GeoSphere01 {
 66;
1.435486;1.435486;5.834286;,
5.282468;0.505339;3.780178;,
-1.187189;4.404957;6.208598;,
5.282468;0.505339;3.780178;,
6.419209;-1.721458;0.131520;,
1.936530;4.752303;4.066310;,
1.936530;4.752303;4.066310;,
-1.187189;4.404957;6.208598;,
1.936530;4.752303;4.066310;,
-4.514314;5.489935;2.435054;,
5.181216;-0.997715;-3.831354;,
3.831658;2.938150;-4.128152;,
1.936530;4.752303;4.066310;,
3.831658;2.938150;-4.128152;,
0.410576;4.802894;-2.006385;,
1.936530;4.752303;4.066310;,
-3.903205;4.051977;-1.492343;,
-1.360574;-2.145719;4.352734;,
-1.187189;4.404957;6.208598;,
-4.514314;5.489935;2.435054;,
-4.331593;-0.020762;2.082639;,
-4.331593;-0.020762;2.082639;,
-1.360574;-2.145719;4.352734;,
-3.483281;-5.042979;2.272769;,
-4.514314;5.489935;2.435054;,
-3.903205;4.051977;-1.492343;,
-5.331797;1.024335;-3.779334;,
-4.514314;5.489935;2.435054;,
-5.620214;-2.957904;-4.914742;,
-4.446242;-6.333356;-1.752909;,
-1.360574;-2.145719;4.352734;,
-3.483281;-5.042979;2.272769;,
2.920822;-4.642333;3.288585;,
2.920822;-4.642333;3.288585;,
5.282468;0.505339;3.780178;,
2.920822;-4.642333;3.288585;,
-3.483281;-5.042979;2.272769;,
-4.446242;-6.333356;-1.752909;,
-0.254481;-5.730019;-3.329446;,
-3.483281;-5.042979;2.272769;,
3.372281;-3.612524;-3.902803;,
2.920822;-4.642333;3.288585;,
3.372281;-3.612524;-3.902803;,
3.372281;-3.612524;-3.902803;,
5.181216;-0.997715;-3.831354;,
3.372281;-3.612524;-3.902803;,
3.831658;2.938150;-4.128152;,
3.372281;-3.612524;-3.902803;,
-0.254481;-5.730019;-3.329446;,
1.502219;-0.046761;-6.951524;,
3.372281;-3.612524;-3.902803;,
3.831658;2.938150;-4.128152;,
3.831658;2.938150;-4.128152;,
0.410576;4.802894;-2.006385;,
-0.254481;-5.730019;-3.329446;,
-4.446242;-6.333356;-1.752909;,
-5.620214;-2.957904;-4.914742;,
-0.254481;-5.730019;-3.329446;,
-5.620214;-2.957904;-4.914742;,
-5.620214;-2.957904;-4.914742;,
-5.331797;1.024335;-3.779334;,
-5.331797;1.024335;-3.779334;,
0.410576;4.802894;-2.006385;,
0.410576;4.802894;-2.006385;,
-5.331797;1.024335;-3.779334;,
-3.903205;4.051977;-1.492343;;

 36;
3;0,1,2;,
3;3,4,5;,
3;1,6,2;,
3;7,8,9;,
3;4,10,11;,
3;4,11,5;,
3;12,13,14;,
3;15,14,9;,
3;9,14,16;,
3;0,2,17;,
3;18,19,20;,
3;2,21,17;,
3;22,20,23;,
3;24,25,26;,
3;27,26,20;,
3;20,26,28;,
3;20,28,23;,
3;23,28,29;,
3;0,17,1;,
3;30,31,32;,
3;17,33,1;,
3;34,35,4;,
3;36,37,38;,
3;39,38,32;,
3;32,38,40;,
3;41,42,4;,
3;4,43,10;,
3;44,45,46;,
3;47,48,49;,
3;50,49,51;,
3;52,49,53;,
3;54,55,56;,
3;57,58,49;,
3;49,59,60;,
3;49,61,62;,
3;63,64,65;;
MeshMaterialList {
 1;
 36;
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
 0.764706;0.764706;0.764706;1.000000;;
12.996039;
 0.007843;0.007843;0.007843;;
 0.000000;0.000000;0.000000;;
TextureFilename {
"ROCK.BMP";
}
 }
}

 MeshNormals {
 66;
0.237559;-0.176458;0.955211;,
0.396909;-0.005132;0.917843;,
0.052042;0.074378;0.995871;,
0.773651;0.618717;-0.136575;,
0.997146;-0.058491;-0.047730;,
0.812946;0.581533;-0.030631;,
0.504675;0.344265;0.791697;,
0.052034;0.971009;0.233309;,
0.052034;0.971009;0.233309;,
-0.010658;0.998536;-0.053035;,
0.940009;-0.126618;-0.316781;,
0.900928;0.426366;-0.080875;,
0.427677;0.898385;-0.099983;,
0.427677;0.898385;-0.099983;,
0.120498;0.978099;-0.169713;,
0.118976;0.992662;-0.021627;,
-0.201674;0.909195;-0.364269;,
-0.111511;-0.318589;0.941311;,
-0.757841;-0.066634;0.649028;,
-0.757841;-0.066634;0.649028;,
-0.906812;-0.066918;0.416190;,
-0.676507;-0.184108;0.713051;,
-0.640396;-0.079249;0.763945;,
-0.890994;-0.112588;0.439834;,
-0.731317;0.595810;-0.331941;,
-0.731317;0.595810;-0.331941;,
-0.978092;0.208171;0.000240;,
-0.986085;-0.042966;0.160591;,
-0.971581;-0.074253;0.224758;,
-0.961451;-0.091491;0.259310;,
-0.100292;-0.530710;0.841599;,
-0.100292;-0.530710;0.841599;,
0.166369;-0.923595;0.345388;,
0.148457;-0.161284;0.975678;,
0.775287;-0.402193;0.487002;,
0.775287;-0.402193;0.487002;,
0.228498;-0.941644;0.247174;,
0.228498;-0.941644;0.247174;,
0.260400;-0.960075;0.102212;,
0.039057;-0.988839;0.143778;,
0.490980;-0.866170;-0.093213;,
0.597241;-0.798373;-0.076834;,
0.597241;-0.798373;-0.076834;,
0.777835;-0.528830;-0.339575;,
0.098720;-0.041127;-0.994265;,
0.098720;-0.041127;-0.994265;,
0.098720;-0.041127;-0.994265;,
0.207504;-0.570562;-0.794607;,
0.207504;-0.570562;-0.794607;,
0.076141;0.104854;-0.991569;,
0.807390;-0.076744;-0.585006;,
0.807390;-0.076744;-0.585006;,
-0.051753;0.707274;-0.705042;,
-0.051753;0.707274;-0.705042;,
-0.159079;-0.703835;-0.692322;,
-0.159079;-0.703835;-0.692322;,
-0.159079;-0.703835;-0.692322;,
-0.024682;-0.531852;-0.846478;,
-0.024682;-0.531852;-0.846478;,
-0.367861;0.279508;-0.886879;,
-0.367861;0.279508;-0.886879;,
-0.223113;0.670894;-0.707193;,
-0.223113;0.670894;-0.707193;,
-0.200427;0.648968;-0.733941;,
-0.200427;0.648968;-0.733941;,
-0.200427;0.648968;-0.733941;;

 36;
3;0,1,2;,
3;3,4,5;,
3;1,6,2;,
3;7,8,9;,
3;4,10,11;,
3;4,11,5;,
3;12,13,14;,
3;15,14,9;,
3;9,14,16;,
3;0,2,17;,
3;18,19,20;,
3;2,21,17;,
3;22,20,23;,
3;24,25,26;,
3;27,26,20;,
3;20,26,28;,
3;20,28,23;,
3;23,28,29;,
3;0,17,1;,
3;30,31,32;,
3;17,33,1;,
3;34,35,4;,
3;36,37,38;,
3;39,38,32;,
3;32,38,40;,
3;41,42,4;,
3;4,43,10;,
3;44,45,46;,
3;47,48,49;,
3;50,49,51;,
3;52,49,53;,
3;54,55,56;,
3;57,58,49;,
3;49,59,60;,
3;49,61,62;,
3;63,64,65;;
 }
MeshTextureCoords {
 66;
0.467141;0.500000;,
0.845344;0.500000;,
0.278039;0.172466;,
0.500000;-0.004339;,
0.500000;0.320810;,
0.969732;0.174899;,
0.738341;0.030268;,
0.721961;-0.004339;,
0.261659;0.174899;,
0.836918;0.320810;,
0.500000;0.718943;,
0.827533;0.855670;,
0.261659;0.174899;,
0.113843;0.855670;,
0.458715;0.855670;,
0.261659;0.174899;,
0.832658;0.718943;,
0.278039;0.827534;,
0.172466;-0.004339;,
-0.026646;0.320810;,
0.500000;0.174899;,
-0.075259;0.500000;,
0.827534;-0.004339;,
1.026646;0.320810;,
-0.026646;0.320810;,
-0.019267;0.718943;,
0.300888;0.855670;,
-0.026646;0.320810;,
0.699112;0.855670;,
1.019267;0.718943;,
0.278039;-0.004339;,
0.163082;0.320810;,
0.738340;0.174899;,
0.738340;0.969732;,
0.500000;-0.004339;,
0.030268;0.174899;,
0.163082;0.320810;,
0.167342;0.718943;,
0.541285;0.855670;,
0.163082;0.320810;,
0.886157;0.855670;,
0.030268;0.174899;,
0.172466;0.855670;,
0.172466;0.855670;,
-0.066738;0.500000;,
0.113843;0.827534;,
0.113843;0.172467;,
0.113843;0.827534;,
0.458715;1.026646;,
0.400596;0.500000;,
0.113843;0.827534;,
0.113843;0.172467;,
0.113843;0.172467;,
0.458715;-0.026645;,
0.458715;1.026646;,
0.832658;1.019267;,
1.026020;0.699112;,
0.458715;1.026646;,
1.026020;0.699112;,
1.026020;0.699112;,
1.026020;0.300888;,
1.026020;0.300888;,
0.458715;-0.026645;,
0.458715;-0.026645;,
1.026020;0.300888;,
0.832658;-0.019267;;
}
}
 }