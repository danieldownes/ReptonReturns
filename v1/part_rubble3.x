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
Frame rubble {
   FrameTransformMatrix {
1.435375,0.000000,0.000000,0.000000,
0.000000,1.435375,0.000000,0.000000,
0.000000,0.000000,1.435375,0.000000,
0.068781,-0.278172,0.000000,1.000000;;
 }
Mesh rubble1 {
 72;
3.594049;3.594049;8.204384;,
6.960273;1.136858;7.111072;,
-0.238932;5.529520;6.382143;,
6.960273;1.136858;7.111072;,
8.234180;-0.314770;2.371918;,
2.855441;6.629885;5.365386;,
6.960273;1.136858;7.111072;,
2.855441;6.629885;5.365386;,
-0.238932;5.529520;6.382143;,
2.855441;6.629885;5.365386;,
-2.843952;5.116123;3.296535;,
7.324370;0.800829;-1.573023;,
5.656466;4.485807;-2.828911;,
2.855441;6.629885;5.365386;,
5.656466;4.485807;-2.828911;,
1.361476;6.341479;-0.239509;,
2.855441;6.629885;5.365386;,
-1.854861;5.092907;-0.702430;,
3.594049;3.594049;8.204384;,
-0.238932;5.529520;6.382143;,
-0.755098;-1.021155;5.235476;,
-0.238932;5.529520;6.382143;,
-2.843952;5.116123;3.296535;,
-2.955375;-0.849150;2.786756;,
-0.238932;5.529520;6.382143;,
-0.755098;-1.021155;5.235476;,
-0.755098;-1.021155;5.235476;,
-4.053800;-5.416791;1.098945;,
-3.506080;2.311466;-4.520046;,
-2.843952;5.116123;3.296535;,
-3.506080;2.311466;-4.520046;,
-3.506080;2.311466;-4.520046;,
-4.892860;-1.670773;-3.476295;,
-2.811841;-5.292426;-2.847467;,
3.594049;3.594049;8.204384;,
6.960273;1.136858;7.111072;,
-4.053800;-5.416791;1.098945;,
1.942314;-2.764750;4.006499;,
6.960273;1.136858;7.111072;,
6.960273;1.136858;7.111072;,
1.942314;-2.764750;4.006499;,
8.234180;-0.314770;2.371918;,
-4.053800;-5.416791;1.098945;,
-2.811841;-5.292426;-2.847467;,
1.272940;-4.191433;-3.509381;,
-4.053800;-5.416791;1.098945;,
1.942314;-2.764750;4.006499;,
1.942314;-2.764750;4.006499;,
4.030698;-2.064867;-2.163410;,
1.942314;-2.764750;4.006499;,
8.234180;-0.314770;2.371918;,
8.234180;-0.314770;2.371918;,
7.324370;0.800829;-1.573023;,
7.324370;0.800829;-1.573023;,
4.030698;-2.064867;-2.163410;,
5.656466;4.485807;-2.828911;,
4.030698;-2.064867;-2.163410;,
1.272940;-4.191433;-3.509381;,
0.538844;-0.543357;-3.835580;,
4.030698;-2.064867;-2.163410;,
5.656466;4.485807;-2.828911;,
5.656466;4.485807;-2.828911;,
1.361476;6.341479;-0.239509;,
1.272940;-4.191433;-3.509381;,
-2.811841;-5.292426;-2.847467;,
-4.892860;-1.670773;-3.476295;,
1.272940;-4.191433;-3.509381;,
-4.892860;-1.670773;-3.476295;,
-4.892860;-1.670773;-3.476295;,
-3.506080;2.311466;-4.520046;,
-3.506080;2.311466;-4.520046;,
1.361476;6.341479;-0.239509;;

 36;
3;0,1,2;,
3;3,4,5;,
3;6,7,8;,
3;2,9,10;,
3;4,11,12;,
3;4,12,5;,
3;13,14,15;,
3;16,15,10;,
3;10,15,17;,
3;18,19,20;,
3;21,22,23;,
3;24,23,25;,
3;26,23,27;,
3;10,17,28;,
3;29,30,23;,
3;23,31,32;,
3;23,32,27;,
3;27,32,33;,
3;34,20,35;,
3;20,36,37;,
3;20,37,38;,
3;39,40,41;,
3;42,43,44;,
3;45,44,46;,
3;47,44,48;,
3;49,48,50;,
3;51,48,52;,
3;53,54,55;,
3;56,57,58;,
3;59,58,60;,
3;61,58,62;,
3;63,64,65;,
3;66,67,58;,
3;58,68,69;,
3;58,70,71;,
3;15,28,17;;
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
 72;
0.523729;0.820082;-0.230594;,
0.523729;0.820082;-0.230594;,
0.127414;0.990025;-0.060133;,
0.796274;0.604243;0.028960;,
0.851045;0.524804;0.017405;,
0.804204;0.589198;0.078111;,
0.153748;0.401783;0.902736;,
0.153748;0.401783;0.902736;,
0.153748;0.401783;0.902736;,
-0.296294;0.947110;0.123256;,
-0.419136;0.907315;-0.033241;,
0.918931;0.380359;-0.104368;,
0.875724;0.482676;0.011490;,
0.323602;0.936592;-0.134448;,
0.323602;0.936592;-0.134448;,
-0.143215;0.972005;-0.186269;,
-0.263640;0.964400;0.020648;,
-0.457837;0.847784;-0.267671;,
-0.473471;-0.115542;0.873198;,
-0.473471;-0.115542;0.873198;,
-0.169651;-0.484127;0.858394;,
-0.760732;-0.041147;0.647760;,
-0.760732;-0.041147;0.647760;,
-0.891699;0.060497;0.448568;,
-0.744605;-0.057734;0.665003;,
-0.744605;-0.057734;0.665003;,
-0.744506;-0.066431;0.664303;,
-0.951685;-0.172395;0.254118;,
-0.505713;0.786571;-0.354346;,
-0.996709;0.011763;0.080209;,
-0.996709;0.011763;0.080209;,
-0.899026;0.373142;0.229164;,
-0.996115;-0.005642;0.087877;,
-0.813167;-0.514498;-0.272122;,
-0.074555;-0.488867;0.869166;,
-0.074555;-0.488867;0.869166;,
-0.077563;-0.651765;0.754444;,
-0.051624;-0.627479;0.776920;,
-0.025594;-0.602083;0.798023;,
0.418779;-0.830626;0.366995;,
0.418779;-0.830626;0.366995;,
0.418779;-0.830626;0.366995;,
0.268021;-0.961897;0.054035;,
0.268021;-0.961897;0.054035;,
0.399104;-0.911201;0.102122;,
0.340063;-0.928991;0.146057;,
0.340063;-0.928991;0.146057;,
0.575484;-0.811332;0.102756;,
0.548497;-0.832706;-0.075839;,
0.367008;-0.930029;0.018727;,
0.367008;-0.930029;0.018727;,
0.650982;-0.677784;-0.341806;,
0.650982;-0.677784;-0.341806;,
0.318140;-0.173642;-0.932006;,
0.318140;-0.173642;-0.932006;,
0.318140;-0.173642;-0.932006;,
0.434327;0.006859;-0.900729;,
0.434327;0.006859;-0.900729;,
0.153835;0.059868;-0.986281;,
0.359016;-0.182099;-0.915395;,
0.359016;-0.182099;-0.915395;,
-0.298082;0.469663;-0.831002;,
-0.298082;0.469663;-0.831002;,
-0.096773;-0.223989;-0.969775;,
-0.096773;-0.223989;-0.969775;,
-0.096773;-0.223989;-0.969775;,
-0.045411;-0.098031;-0.994147;,
-0.045411;-0.098031;-0.994147;,
-0.012257;-0.249522;-0.968291;,
-0.012257;-0.249522;-0.968291;,
0.410451;0.383163;-0.827476;,
0.410451;0.383163;-0.827476;;

 36;
3;0,1,2;,
3;3,4,5;,
3;6,7,8;,
3;2,9,10;,
3;4,11,12;,
3;4,12,5;,
3;13,14,15;,
3;16,15,10;,
3;10,15,17;,
3;18,19,20;,
3;21,22,23;,
3;24,23,25;,
3;26,23,27;,
3;10,17,28;,
3;29,30,23;,
3;23,31,32;,
3;23,32,27;,
3;27,32,33;,
3;34,20,35;,
3;20,36,37;,
3;20,37,38;,
3;39,40,41;,
3;42,43,44;,
3;45,44,46;,
3;47,44,48;,
3;49,48,50;,
3;51,48,52;,
3;53,54,55;,
3;56,57,58;,
3;59,58,60;,
3;61,58,62;,
3;63,64,65;,
3;66,67,58;,
3;58,68,69;,
3;58,70,71;,
3;15,28,17;;
 }
MeshTextureCoords {
 72;
0.707250;-0.999001;,
0.194894;-0.827328;,
1.290649;-0.712871;,
1.087954;-0.827328;,
0.847195;-0.083182;,
1.999001;-0.553219;,
1.805106;-0.087954;,
1.180330;-0.999001;,
0.709351;-0.816500;,
0.819670;-0.553219;,
1.687146;-0.228366;,
1.032222;0.536257;,
1.643395;0.733457;,
0.819670;-0.553219;,
0.393340;0.733457;,
1.047059;0.326867;,
0.819670;-0.553219;,
1.536602;0.399555;,
1.292750;-0.495492;,
0.709351;-0.816500;,
0.630787;0.269963;,
0.183500;-0.712871;,
0.252064;-0.228366;,
1.241435;-0.148320;,
0.183500;-0.712871;,
1.269963;-0.532820;,
1.269963;-0.532820;,
1.999001;0.116702;,
1.787926;0.999001;,
0.252064;-0.228366;,
0.717230;0.999001;,
0.717230;0.999001;,
1.377705;0.835110;,
1.978374;0.736371;,
1.292750;-0.495492;,
1.805106;-0.087954;,
0.128708;0.999001;,
1.041347;0.559147;,
1.805106;-0.087954;,
1.805106;-0.827328;,
1.041347;-0.339845;,
1.999001;-0.083182;,
0.128708;0.116702;,
0.317741;0.736371;,
0.939465;0.840305;,
0.128708;0.116702;,
1.041347;-0.339845;,
1.041347;-0.339845;,
1.359210;0.628960;,
1.041347;-0.339845;,
1.999001;-0.083182;,
1.999001;-0.083182;,
1.860523;0.536257;,
0.139477;-0.032222;,
0.640790;0.443068;,
0.393340;-0.643395;,
0.640790;0.443068;,
1.060535;0.795769;,
1.172268;0.190717;,
0.640790;0.443068;,
0.393340;-0.643395;,
0.393340;-0.643395;,
1.047059;-0.951167;,
1.060535;0.795769;,
1.682259;0.978374;,
1.999001;0.377705;,
1.060535;0.795769;,
1.999001;0.377705;,
1.999001;0.377705;,
1.787926;-0.282770;,
1.787926;-0.282770;,
1.047059;-0.951167;;
}
}
 }