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
Frame Line04 {
   FrameTransformMatrix {
1.000000,0.000000,0.000000,0.000000,
0.000000,0.000000,1.000000,0.000000,
0.000000,-1.000000,0.000000,0.000000,
59.225098,-0.000001,1.542132,1.000000;;
 }
Mesh Line041 {
 198;
1.522305;-16.171562;0.000000;,
38.968796;-1.376391;0.000000;,
27.720245;-1.197254;1.513106;,
1.524689;-11.547159;1.513106;,
38.968796;-1.376391;0.000000;,
0.606895;15.211425;0.000000;,
0.685719;10.492565;1.513106;,
27.720245;-1.197254;1.513106;,
-35.091900;-1.661577;0.000000;,
-24.295494;-1.314779;1.513106;,
-35.091900;-1.661577;0.000000;,
-24.295494;-1.314779;1.513106;,
1.188808;-0.635779;8.013105;,
1.188808;-0.635779;8.013105;,
1.522301;-16.171566;-0.552774;,
27.720230;-1.197254;-2.065878;,
38.968788;-1.376392;-0.552771;,
1.524681;-11.547162;-2.065880;,
38.968788;-1.376392;-0.552771;,
0.685715;10.492568;-2.065875;,
0.606892;15.211429;-0.552769;,
27.720230;-1.197254;-2.065878;,
-24.295494;-1.314779;-2.065878;,
-35.091896;-1.661577;-0.552771;,
-35.091896;-1.661577;-0.552771;,
-24.295494;-1.314779;-2.065878;,
1.188805;-0.635778;-8.565879;,
1.188805;-0.635778;-8.565879;,
62.714500;36.002899;-0.111245;,
39.358200;54.010742;-0.111241;,
49.147614;35.748867;-0.111248;,
48.445389;-44.131268;-0.111226;,
40.617828;-56.616779;-0.111229;,
63.597443;-42.722984;-0.111237;,
68.842773;16.609373;-0.111233;,
56.735962;0.517439;-0.111237;,
71.312042;0.559331;-0.111241;,
70.083618;-19.709372;-0.111233;,
3.036568;-73.995338;0.000000;,
-26.154579;-94.880814;0.000000;,
-7.556084;-89.760963;1.495193;,
7.895691;-80.237312;1.495193;,
14.082726;-95.488289;-0.000001;,
13.484024;-90.078613;1.495193;,
6.266266;91.253204;0.000000;,
-26.185944;90.778709;0.000000;,
-9.816582;85.617455;1.495193;,
5.814011;85.845993;1.495193;,
1.630234;70.689255;0.000000;,
5.568130;74.506264;1.495193;,
50.743835;83.090126;0.000000;,
48.545387;78.003395;1.495193;,
24.754311;36.473301;0.000000;,
29.849373;38.578121;1.495193;,
83.968719;58.641518;0.000000;,
79.738358;55.049980;1.495193;,
52.716309;-86.216232;-0.000001;,
50.421272;-81.213669;1.495193;,
25.526985;-40.021160;0.000000;,
30.704651;-41.879265;1.495193;,
82.609650;-64.661919;-0.000001;,
78.467758;-60.991035;1.495192;,
99.961960;27.265625;0.000000;,
94.756729;25.586611;1.495193;,
31.708359;0.157747;0.000000;,
37.187294;0.257886;1.495193;,
103.825333;2.153812;0.000000;,
98.400269;1.903764;1.495193;,
101.893646;-29.718872;0.000000;,
96.577225;-28.176258;1.495193;,
15.811493;-83.313362;5.794775;,
15.811493;-83.313362;5.794775;,
15.681602;-83.348724;5.794775;,
7.895691;-80.237312;1.495193;,
15.681602;-83.348724;5.794775;,
15.681602;-83.348724;5.794775;,
15.811493;-83.313362;5.794775;,
-7.556084;-89.760963;1.495193;,
10.571915;78.572487;5.794759;,
10.571915;78.572487;5.794759;,
45.207001;70.279121;5.794760;,
35.882202;41.774323;6.836551;,
68.033157;49.596161;3.523754;,
46.936218;-73.617218;5.794775;,
15.681602;-83.348724;5.794775;,
36.088440;-44.700836;7.878317;,
66.896889;-55.416733;4.565521;,
81.571182;23.037001;5.624321;,
44.561119;0.409944;11.026014;,
84.880875;1.524058;7.713216;,
83.222824;-25.833757;5.624321;,
31.601349;59.491219;1.313258;,
47.097557;56.651810;1.313256;,
35.882202;41.774323;6.836551;,
41.430511;44.979042;1.313256;,
68.451134;39.126080;1.313248;,
36.088440;-44.700836;7.878317;,
31.256714;-63.519699;1.313256;,
41.011475;-47.370930;1.313260;,
46.936218;-73.617218;5.794775;,
43.404617;-61.801964;1.313256;,
66.896889;-55.416733;4.565521;,
67.558662;-44.522415;1.313251;,
81.571182;23.037001;5.624321;,
75.093811;18.067085;1.313245;,
44.561119;0.409944;11.026014;,
50.215561;0.500949;1.313256;,
84.880875;1.524058;7.713216;,
77.741730;0.855684;1.313244;,
83.222824;-25.833757;5.624321;,
76.413300;-21.063284;1.313245;,
62.714485;36.002930;-0.441517;,
49.147598;35.748898;-0.441514;,
39.358200;54.010784;-0.441517;,
48.445389;-44.131294;-0.441558;,
63.597427;-42.723011;-0.441546;,
40.617828;-56.616817;-0.441557;,
68.842773;16.609388;-0.441534;,
56.735954;0.517443;-0.441534;,
71.312012;0.559335;-0.441531;,
70.083603;-19.709383;-0.441544;,
3.036594;-73.995392;-0.552791;,
-7.556053;-89.761024;-2.047989;,
-26.154533;-94.880875;-0.552796;,
7.895706;-80.237366;-2.047987;,
13.484039;-90.078674;-2.047989;,
14.082741;-95.488358;-0.552796;,
6.266289;91.253273;-0.552748;,
-9.816547;85.617516;-2.047943;,
-26.185898;90.778778;-0.552748;,
5.814026;85.846062;-2.047943;,
5.568161;74.506317;-2.047946;,
1.630260;70.689308;-0.552753;,
50.743828;83.090187;-0.552750;,
48.545380;78.003456;-2.047945;,
29.849380;38.578152;-2.047955;,
24.754318;36.473331;-0.552762;,
83.968689;58.641563;-0.552756;,
79.738342;55.050022;-2.047951;,
50.421265;-81.213722;-2.047987;,
52.716301;-86.216293;-0.552794;,
25.526993;-40.021187;-0.552782;,
30.704659;-41.879292;-2.047976;,
78.467743;-60.991077;-2.047981;,
82.609619;-64.661964;-0.552787;,
99.961914;27.265648;-0.552764;,
94.756699;25.586632;-2.047959;,
37.187302;0.257889;-2.047965;,
31.708366;0.157751;-0.552771;,
103.825287;2.153817;-0.552771;,
98.400223;1.903769;-2.047966;,
101.893600;-29.718889;-0.552779;,
96.577194;-28.176275;-2.047973;,
15.811516;-83.313416;-6.347572;,
15.811516;-83.313416;-6.347572;,
7.895706;-80.237366;-2.047987;,
15.681618;-83.348778;-6.347572;,
15.681618;-83.348778;-6.347572;,
15.681618;-83.348778;-6.347572;,
-7.556053;-89.761024;-2.047989;,
15.811516;-83.313416;-6.347572;,
10.571938;78.572548;-6.347514;,
10.571938;78.572548;-6.347514;,
45.207001;70.279175;-6.347517;,
35.882202;41.774357;-7.389316;,
68.033142;49.596199;-4.076515;,
46.936218;-73.617264;-6.347569;,
15.681618;-83.348778;-6.347572;,
36.088448;-44.700863;-8.431107;,
66.896866;-55.416767;-5.118310;,
81.571152;23.037022;-6.177090;,
44.561111;0.409949;-11.578794;,
84.880859;1.524063;-8.265993;,
83.222794;-25.833773;-6.177103;,
31.601357;59.491264;-1.866015;,
47.097549;56.651855;-1.866014;,
41.430511;44.979076;-1.866017;,
35.882202;41.774357;-7.389316;,
68.451111;39.126110;-1.866010;,
36.088448;-44.700863;-8.431107;,
31.256714;-63.519741;-1.866045;,
41.011475;-47.370960;-1.866045;,
43.404617;-61.802006;-1.866045;,
46.936218;-73.617264;-6.347569;,
67.558647;-44.522442;-1.866035;,
66.896866;-55.416767;-5.118310;,
81.571152;23.037022;-6.177090;,
75.093781;18.067102;-1.866013;,
50.215561;0.500953;-1.866028;,
44.561111;0.409949;-11.578794;,
84.880859;1.524063;-8.265993;,
77.741699;0.855688;-1.866017;,
83.222794;-25.833773;-6.177103;,
76.413269;-21.063295;-1.866023;,
72.975800;92.965981;0.000018;,
72.975800;73.605446;0.000016;,
102.016571;92.965981;0.000018;,
102.016571;73.605446;0.000016;;

 258;
3;0,1,2;,
3;2,3,0;,
3;4,5,6;,
3;6,7,4;,
3;5,8,9;,
3;9,6,5;,
3;10,0,3;,
3;3,11,10;,
3;3,2,12;,
3;7,6,13;,
3;6,9,13;,
3;11,3,12;,
3;14,15,16;,
3;15,14,17;,
3;18,19,20;,
3;19,18,21;,
3;20,22,23;,
3;22,20,19;,
3;24,17,14;,
3;17,24,25;,
3;17,26,15;,
3;21,27,19;,
3;19,27,22;,
3;25,26,17;,
3;28,29,30;,
3;31,32,33;,
3;34,28,30;,
3;34,30,35;,
3;36,34,35;,
3;37,36,35;,
3;37,35,31;,
3;37,31,33;,
3;38,39,40;,
3;40,41,38;,
3;39,42,43;,
3;43,40,39;,
3;44,45,46;,
3;46,47,44;,
3;45,48,49;,
3;49,46,45;,
3;50,44,47;,
3;47,51,50;,
3;48,52,53;,
3;53,49,48;,
3;54,50,51;,
3;51,55,54;,
3;42,56,57;,
3;57,43,42;,
3;58,38,41;,
3;41,59,58;,
3;56,60,61;,
3;61,57,56;,
3;62,54,55;,
3;55,63,62;,
3;52,64,65;,
3;65,53,52;,
3;66,62,63;,
3;63,67,66;,
3;68,66,67;,
3;67,69,68;,
3;64,58,59;,
3;59,65,64;,
3;60,68,69;,
3;69,61,60;,
3;41,40,70;,
3;71,72,73;,
3;40,43,74;,
3;75,76,77;,
3;47,46,78;,
3;46,49,79;,
3;51,47,78;,
3;78,80,51;,
3;49,53,81;,
3;81,79,49;,
3;55,51,80;,
3;80,82,55;,
3;43,57,83;,
3;83,74,43;,
3;59,41,84;,
3;84,85,59;,
3;57,61,86;,
3;86,83,57;,
3;63,55,82;,
3;82,87,63;,
3;53,65,88;,
3;88,81,53;,
3;67,63,87;,
3;87,89,67;,
3;69,67,89;,
3;89,90,69;,
3;65,59,85;,
3;85,88,65;,
3;61,69,90;,
3;90,86,61;,
3;80,79,91;,
3;91,92,80;,
3;78,93,94;,
3;94,91,78;,
3;82,80,92;,
3;92,95,82;,
3;96,74,97;,
3;97,98,96;,
3;84,99,100;,
3;100,97,84;,
3;99,101,102;,
3;102,100,99;,
3;103,82,95;,
3;95,104,103;,
3;93,105,106;,
3;106,94,93;,
3;107,103,104;,
3;104,108,107;,
3;109,107,108;,
3;108,110,109;,
3;105,96,98;,
3;98,106,105;,
3;101,109,110;,
3;110,102,101;,
3;92,91,29;,
3;91,94,30;,
3;30,29,91;,
3;95,92,29;,
3;29,28,95;,
3;98,97,32;,
3;32,31,98;,
3;97,100,32;,
3;100,102,33;,
3;33,32,100;,
3;104,95,28;,
3;28,34,104;,
3;94,106,35;,
3;35,30,94;,
3;108,104,34;,
3;34,36,108;,
3;110,108,36;,
3;36,37,110;,
3;106,98,31;,
3;31,35,106;,
3;102,110,37;,
3;37,33,102;,
3;111,112,113;,
3;114,115,116;,
3;117,112,111;,
3;117,118,112;,
3;119,118,117;,
3;120,118,119;,
3;120,114,118;,
3;120,115,114;,
3;121,122,123;,
3;122,121,124;,
3;123,125,126;,
3;125,123,122;,
3;127,128,129;,
3;128,127,130;,
3;129,131,132;,
3;131,129,128;,
3;133,130,127;,
3;130,133,134;,
3;132,135,136;,
3;135,132,131;,
3;137,134,133;,
3;134,137,138;,
3;126,139,140;,
3;139,126,125;,
3;141,124,121;,
3;124,141,142;,
3;140,143,144;,
3;143,140,139;,
3;145,138,137;,
3;138,145,146;,
3;136,147,148;,
3;147,136,135;,
3;149,146,145;,
3;146,149,150;,
3;151,150,149;,
3;150,151,152;,
3;148,142,141;,
3;142,148,147;,
3;144,152,151;,
3;152,144,143;,
3;124,153,122;,
3;154,155,156;,
3;122,157,125;,
3;158,159,160;,
3;130,161,128;,
3;128,162,131;,
3;134,161,130;,
3;161,134,163;,
3;131,164,135;,
3;164,131,162;,
3;138,163,134;,
3;163,138,165;,
3;125,166,139;,
3;166,125,157;,
3;142,167,124;,
3;167,142,168;,
3;139,169,143;,
3;169,139,166;,
3;146,165,138;,
3;165,146,170;,
3;135,171,147;,
3;171,135,164;,
3;150,170,146;,
3;170,150,172;,
3;152,172,150;,
3;172,152,173;,
3;147,168,142;,
3;168,147,171;,
3;143,173,152;,
3;173,143,169;,
3;163,174,162;,
3;174,163,175;,
3;161,176,177;,
3;176,161,174;,
3;165,175,163;,
3;175,165,178;,
3;179,180,157;,
3;180,179,181;,
3;167,182,183;,
3;182,167,180;,
3;183,184,185;,
3;184,183,182;,
3;186,178,165;,
3;178,186,187;,
3;177,188,189;,
3;188,177,176;,
3;190,187,186;,
3;187,190,191;,
3;192,191,190;,
3;191,192,193;,
3;189,181,179;,
3;181,189,188;,
3;185,193,192;,
3;193,185,184;,
3;175,113,174;,
3;174,112,176;,
3;112,174,113;,
3;178,113,175;,
3;113,178,111;,
3;181,116,180;,
3;116,181,114;,
3;180,116,182;,
3;182,115,184;,
3;115,182,116;,
3;187,111,178;,
3;111,187,117;,
3;176,118,188;,
3;118,176,112;,
3;191,117,187;,
3;117,191,119;,
3;193,119,191;,
3;119,193,120;,
3;188,114,181;,
3;114,188,118;,
3;184,120,193;,
3;120,184,115;,
3;194,195,196;,
3;197,196,195;;
MeshMaterialList {
 1;
 258;
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
 1.000000;1.000000;1.000000;1.000000;;
11.313708;
 1.000000;1.000000;1.000000;;
 1.000000;1.000000;1.000000;;
TextureFilename {
"d.bmp";
}
 }
}

 MeshNormals {
 198;
0.040823;-0.310737;0.949619;,
0.121973;-0.308712;0.943303;,
0.147650;-0.373701;0.915722;,
-0.025784;-0.392866;0.919234;,
0.131741;0.304671;0.943303;,
-0.051075;0.304166;0.951249;,
0.022322;0.386554;0.921997;,
0.175141;0.405040;0.897367;,
-0.141843;0.300102;0.943303;,
-0.171676;0.363221;0.915750;,
-0.122291;-0.308586;0.943303;,
-0.162536;-0.410141;0.897422;,
-0.002042;-0.511827;0.859086;,
-0.006337;0.504137;0.863600;,
0.040823;-0.310737;-0.949619;,
0.147650;-0.373700;-0.915722;,
0.121973;-0.308712;-0.943303;,
-0.025784;-0.392866;-0.919234;,
0.131741;0.304671;-0.943303;,
0.022322;0.386554;-0.921997;,
-0.051075;0.304166;-0.951249;,
0.175141;0.405040;-0.897367;,
-0.171676;0.363221;-0.915750;,
-0.141843;0.300102;-0.943302;,
-0.122291;-0.308586;-0.943303;,
-0.162536;-0.410140;-0.897422;,
-0.002042;-0.511827;-0.859086;,
-0.006337;0.504137;-0.863600;,
-0.111880;-0.063296;0.991704;,
-0.010110;-0.106583;0.994252;,
0.201379;0.110007;0.973316;,
0.112518;-0.039783;0.992853;,
0.073269;0.027370;0.996937;,
-0.127807;0.116490;0.984934;,
-0.106749;-0.022056;0.994041;,
0.095988;0.007821;0.995352;,
-0.130452;-0.001358;0.991454;,
-0.121507;0.029447;0.992154;,
-0.129633;0.148511;0.980377;,
-0.046295;-0.121393;0.991524;,
-0.111848;-0.002110;0.993723;,
-0.237051;0.222320;0.945717;,
0.040194;-0.262054;0.964216;,
0.056095;-0.397218;0.916008;,
0.013460;0.265447;0.964032;,
-0.108601;-0.056927;0.992454;,
-0.109145;0.078355;0.990933;,
0.037799;0.374572;0.926427;,
-0.199666;-0.171889;0.964670;,
-0.313894;-0.286755;0.905120;,
0.084968;0.247012;0.965280;,
0.143168;0.348982;0.926129;,
-0.248740;-0.083371;0.964976;,
-0.458105;-0.156545;0.875005;,
0.184995;0.183990;0.965362;,
0.200539;0.160443;0.966459;,
0.124952;-0.231065;0.964881;,
0.151124;-0.291208;0.944648;,
-0.219105;0.095137;0.971052;,
-0.438487;0.150880;0.885982;,
0.208093;-0.158346;0.965207;,
0.193343;-0.177420;0.964956;,
0.246606;0.094390;0.964508;,
0.242471;0.087407;0.966213;,
-0.263433;0.010331;0.964622;,
-0.543382;0.001607;0.839484;,
0.264710;0.021678;0.964084;,
0.320625;0.029808;0.946737;,
0.255842;-0.053822;0.965219;,
0.284338;-0.089881;0.954502;,
-0.281235;0.456293;0.844217;,
0.170342;-0.625689;-0.761247;,
0.170342;-0.625689;-0.761247;,
0.170342;-0.625689;-0.761247;,
0.297386;-0.526080;0.796744;,
-0.262637;0.964702;-0.019264;,
-0.262637;0.964702;-0.019264;,
-0.262637;0.964702;-0.019264;,
0.245071;0.453702;0.856793;,
-0.297157;-0.361102;0.883914;,
0.033851;-0.014145;0.999327;,
-0.548354;-0.237302;0.801870;,
-0.062808;-0.072290;0.995404;,
0.216321;-0.456060;0.863258;,
-0.308686;0.290239;0.905800;,
-0.730441;0.176936;0.659658;,
0.235166;-0.229863;0.944384;,
0.320298;0.134082;0.937780;,
-0.745335;-0.034366;0.665803;,
0.372019;0.011787;0.928150;,
0.246470;-0.126115;0.960910;,
0.218413;-0.011916;0.975784;,
-0.126126;-0.270559;0.954406;,
0.691661;0.252791;0.676537;,
0.472395;0.232956;0.850044;,
-0.276018;-0.162185;0.947370;,
0.696459;-0.325122;0.639719;,
0.341460;-0.100871;0.934468;,
0.526848;-0.194644;0.827372;,
-0.173044;0.303495;0.936988;,
-0.118338;0.267660;0.956219;,
-0.440996;0.253265;0.861034;,
-0.305749;0.218894;0.926608;,
-0.513580;-0.116476;0.850100;,
-0.393095;-0.070964;0.916755;,
0.832109;-0.041845;0.553032;,
0.539557;0.028159;0.841478;,
-0.627765;-0.040733;0.777337;,
-0.426926;-0.023887;0.903971;,
-0.541292;0.072524;0.837701;,
-0.382910;0.100048;0.918352;,
-0.111880;-0.063296;-0.991704;,
0.201380;0.110007;-0.973316;,
-0.010110;-0.106583;-0.994252;,
0.112518;-0.039783;-0.992853;,
-0.127808;0.116490;-0.984934;,
0.073269;0.027370;-0.996937;,
-0.106749;-0.022055;-0.994041;,
0.095988;0.007821;-0.995352;,
-0.130452;-0.001358;-0.991454;,
-0.121507;0.029447;-0.992154;,
-0.129634;0.148511;-0.980377;,
-0.111849;-0.002110;-0.993723;,
-0.046295;-0.121392;-0.991524;,
-0.237052;0.222321;-0.945717;,
0.056095;-0.397218;-0.916008;,
0.040194;-0.262053;-0.964216;,
0.013460;0.265447;-0.964032;,
-0.109145;0.078355;-0.990933;,
-0.108601;-0.056927;-0.992454;,
0.037799;0.374572;-0.926427;,
-0.313894;-0.286755;-0.905120;,
-0.199666;-0.171888;-0.964670;,
0.084968;0.247012;-0.965280;,
0.143169;0.348983;-0.926128;,
-0.458106;-0.156545;-0.875004;,
-0.248740;-0.083371;-0.964976;,
0.184996;0.183990;-0.965362;,
0.200539;0.160443;-0.966458;,
0.151125;-0.291208;-0.944648;,
0.124952;-0.231065;-0.964881;,
-0.219105;0.095137;-0.971052;,
-0.438487;0.150880;-0.885982;,
0.193343;-0.177420;-0.964956;,
0.208094;-0.158346;-0.965206;,
0.246607;0.094391;-0.964508;,
0.242471;0.087408;-0.966213;,
-0.543382;0.001607;-0.839484;,
-0.263433;0.010332;-0.964622;,
0.264711;0.021678;-0.964084;,
0.320625;0.029809;-0.946737;,
0.255842;-0.053822;-0.965219;,
0.284339;-0.089881;-0.954501;,
-0.281235;0.456293;-0.844218;,
0.170335;-0.625699;0.761240;,
0.170335;-0.625699;0.761240;,
0.170335;-0.625699;0.761240;,
0.297386;-0.526080;-0.796744;,
-0.262622;0.964705;0.019350;,
-0.262622;0.964705;0.019350;,
-0.262622;0.964705;0.019350;,
0.245071;0.453702;-0.856793;,
-0.297157;-0.361102;-0.883914;,
0.033851;-0.014145;-0.999327;,
-0.548354;-0.237302;-0.801870;,
-0.062808;-0.072289;-0.995404;,
0.216321;-0.456060;-0.863258;,
-0.308686;0.290239;-0.905800;,
-0.730442;0.176936;-0.659658;,
0.235166;-0.229862;-0.944384;,
0.320299;0.134083;-0.937780;,
-0.745336;-0.034365;-0.665803;,
0.372020;0.011787;-0.928150;,
0.246470;-0.126114;-0.960910;,
0.218414;-0.011916;-0.975784;,
-0.126126;-0.270559;-0.954406;,
0.472396;0.232956;-0.850043;,
0.691661;0.252791;-0.676537;,
-0.276018;-0.162185;-0.947370;,
0.696460;-0.325122;-0.639718;,
0.341461;-0.100871;-0.934468;,
0.526848;-0.194644;-0.827372;,
-0.118338;0.267660;-0.956219;,
-0.173045;0.303495;-0.936988;,
-0.305749;0.218895;-0.926608;,
-0.440997;0.253265;-0.861033;,
-0.513580;-0.116475;-0.850099;,
-0.393096;-0.070964;-0.916755;,
0.539557;0.028159;-0.841478;,
0.832109;-0.041845;-0.553032;,
-0.627764;-0.040732;-0.777337;,
-0.426926;-0.023886;-0.903971;,
-0.541292;0.072525;-0.837701;,
-0.382910;0.100048;-0.918352;,
0.000000;0.000000;1.000000;,
0.000000;0.000000;1.000000;,
0.000000;0.000000;1.000000;,
0.000000;0.000000;1.000000;;

 258;
3;0,1,2;,
3;2,3,0;,
3;4,5,6;,
3;6,7,4;,
3;5,8,9;,
3;9,6,5;,
3;10,0,3;,
3;3,11,10;,
3;3,2,12;,
3;7,6,13;,
3;6,9,13;,
3;11,3,12;,
3;14,15,16;,
3;15,14,17;,
3;18,19,20;,
3;19,18,21;,
3;20,22,23;,
3;22,20,19;,
3;24,17,14;,
3;17,24,25;,
3;17,26,15;,
3;21,27,19;,
3;19,27,22;,
3;25,26,17;,
3;28,29,30;,
3;31,32,33;,
3;34,28,30;,
3;34,30,35;,
3;36,34,35;,
3;37,36,35;,
3;37,35,31;,
3;37,31,33;,
3;38,39,40;,
3;40,41,38;,
3;39,42,43;,
3;43,40,39;,
3;44,45,46;,
3;46,47,44;,
3;45,48,49;,
3;49,46,45;,
3;50,44,47;,
3;47,51,50;,
3;48,52,53;,
3;53,49,48;,
3;54,50,51;,
3;51,55,54;,
3;42,56,57;,
3;57,43,42;,
3;58,38,41;,
3;41,59,58;,
3;56,60,61;,
3;61,57,56;,
3;62,54,55;,
3;55,63,62;,
3;52,64,65;,
3;65,53,52;,
3;66,62,63;,
3;63,67,66;,
3;68,66,67;,
3;67,69,68;,
3;64,58,59;,
3;59,65,64;,
3;60,68,69;,
3;69,61,60;,
3;41,40,70;,
3;71,72,73;,
3;40,43,74;,
3;75,76,77;,
3;47,46,78;,
3;46,49,79;,
3;51,47,78;,
3;78,80,51;,
3;49,53,81;,
3;81,79,49;,
3;55,51,80;,
3;80,82,55;,
3;43,57,83;,
3;83,74,43;,
3;59,41,84;,
3;84,85,59;,
3;57,61,86;,
3;86,83,57;,
3;63,55,82;,
3;82,87,63;,
3;53,65,88;,
3;88,81,53;,
3;67,63,87;,
3;87,89,67;,
3;69,67,89;,
3;89,90,69;,
3;65,59,85;,
3;85,88,65;,
3;61,69,90;,
3;90,86,61;,
3;80,79,91;,
3;91,92,80;,
3;78,93,94;,
3;94,91,78;,
3;82,80,92;,
3;92,95,82;,
3;96,74,97;,
3;97,98,96;,
3;84,99,100;,
3;100,97,84;,
3;99,101,102;,
3;102,100,99;,
3;103,82,95;,
3;95,104,103;,
3;93,105,106;,
3;106,94,93;,
3;107,103,104;,
3;104,108,107;,
3;109,107,108;,
3;108,110,109;,
3;105,96,98;,
3;98,106,105;,
3;101,109,110;,
3;110,102,101;,
3;92,91,29;,
3;91,94,30;,
3;30,29,91;,
3;95,92,29;,
3;29,28,95;,
3;98,97,32;,
3;32,31,98;,
3;97,100,32;,
3;100,102,33;,
3;33,32,100;,
3;104,95,28;,
3;28,34,104;,
3;94,106,35;,
3;35,30,94;,
3;108,104,34;,
3;34,36,108;,
3;110,108,36;,
3;36,37,110;,
3;106,98,31;,
3;31,35,106;,
3;102,110,37;,
3;37,33,102;,
3;111,112,113;,
3;114,115,116;,
3;117,112,111;,
3;117,118,112;,
3;119,118,117;,
3;120,118,119;,
3;120,114,118;,
3;120,115,114;,
3;121,122,123;,
3;122,121,124;,
3;123,125,126;,
3;125,123,122;,
3;127,128,129;,
3;128,127,130;,
3;129,131,132;,
3;131,129,128;,
3;133,130,127;,
3;130,133,134;,
3;132,135,136;,
3;135,132,131;,
3;137,134,133;,
3;134,137,138;,
3;126,139,140;,
3;139,126,125;,
3;141,124,121;,
3;124,141,142;,
3;140,143,144;,
3;143,140,139;,
3;145,138,137;,
3;138,145,146;,
3;136,147,148;,
3;147,136,135;,
3;149,146,145;,
3;146,149,150;,
3;151,150,149;,
3;150,151,152;,
3;148,142,141;,
3;142,148,147;,
3;144,152,151;,
3;152,144,143;,
3;124,153,122;,
3;154,155,156;,
3;122,157,125;,
3;158,159,160;,
3;130,161,128;,
3;128,162,131;,
3;134,161,130;,
3;161,134,163;,
3;131,164,135;,
3;164,131,162;,
3;138,163,134;,
3;163,138,165;,
3;125,166,139;,
3;166,125,157;,
3;142,167,124;,
3;167,142,168;,
3;139,169,143;,
3;169,139,166;,
3;146,165,138;,
3;165,146,170;,
3;135,171,147;,
3;171,135,164;,
3;150,170,146;,
3;170,150,172;,
3;152,172,150;,
3;172,152,173;,
3;147,168,142;,
3;168,147,171;,
3;143,173,152;,
3;173,143,169;,
3;163,174,162;,
3;174,163,175;,
3;161,176,177;,
3;176,161,174;,
3;165,175,163;,
3;175,165,178;,
3;179,180,157;,
3;180,179,181;,
3;167,182,183;,
3;182,167,180;,
3;183,184,185;,
3;184,183,182;,
3;186,178,165;,
3;178,186,187;,
3;177,188,189;,
3;188,177,176;,
3;190,187,186;,
3;187,190,191;,
3;192,191,190;,
3;191,192,193;,
3;189,181,179;,
3;181,189,188;,
3;185,193,192;,
3;193,185,184;,
3;175,113,174;,
3;174,112,176;,
3;112,174,113;,
3;178,113,175;,
3;113,178,111;,
3;181,116,180;,
3;116,181,114;,
3;180,116,182;,
3;182,115,184;,
3;115,182,116;,
3;187,111,178;,
3;111,187,117;,
3;176,118,188;,
3;118,176,112;,
3;191,117,187;,
3;117,191,119;,
3;193,119,191;,
3;119,193,120;,
3;188,114,181;,
3;114,188,118;,
3;184,120,193;,
3;120,184,115;,
3;194,195,196;,
3;197,196,195;;
 }
MeshTextureCoords {
 198;
0.272566;0.583478;,
0.532030;0.508844;,
0.454090;0.507941;,
0.272582;0.560150;,
0.532030;0.508844;,
0.266223;0.425167;,
0.266769;0.448972;,
0.454090;0.507941;,
0.018868;0.510283;,
0.093676;0.508533;,
0.018868;0.510283;,
0.093676;0.508533;,
0.270255;0.505108;,
0.270255;0.505108;,
0.272566;0.583478;,
0.454090;0.507941;,
0.532030;0.508844;,
0.272582;0.560150;,
0.532030;0.508844;,
0.266769;0.448972;,
0.266223;0.425167;,
0.454090;0.507941;,
0.093676;0.508533;,
0.018869;0.510283;,
0.018869;0.510283;,
0.093676;0.508533;,
0.270255;0.505108;,
0.270255;0.505108;,
0.696563;0.320285;,
0.534729;0.229445;,
0.602559;0.321567;,
0.597693;0.724520;,
0.543456;0.787503;,
0.702681;0.717416;,
0.739025;0.418115;,
0.655138;0.499291;,
0.756135;0.499080;,
0.747623;0.601325;,
0.283058;0.875169;,
0.080794;0.980525;,
0.209662;0.954698;,
0.316727;0.906656;,
0.359596;0.983589;,
0.355448;0.956300;,
0.305437;0.041576;,
0.080577;0.043970;,
0.194000;0.070006;,
0.302303;0.068853;,
0.273314;0.145311;,
0.300599;0.126056;,
0.613619;0.082755;,
0.598386;0.108415;,
0.433539;0.317912;,
0.468843;0.307295;,
0.843832;0.206085;,
0.814520;0.224203;,
0.627286;0.936817;,
0.611384;0.911582;,
0.438893;0.703787;,
0.474769;0.713160;,
0.834415;0.828087;,
0.805716;0.809569;,
0.954648;0.364360;,
0.918581;0.372830;,
0.481723;0.501105;,
0.519686;0.500600;,
0.981417;0.491036;,
0.943827;0.492298;,
0.968033;0.651817;,
0.931195;0.644036;,
0.371575;0.922173;,
0.371575;0.922173;,
0.370675;0.922352;,
0.316727;0.906656;,
0.370675;0.922352;,
0.370675;0.922352;,
0.371575;0.922173;,
0.209662;0.954698;,
0.335270;0.105544;,
0.335270;0.105544;,
0.575255;0.147380;,
0.510644;0.291171;,
0.733416;0.251714;,
0.587236;0.873261;,
0.370675;0.922352;,
0.512073;0.727393;,
0.725542;0.781449;,
0.827220;0.385691;,
0.570779;0.499833;,
0.850152;0.494213;,
0.838664;0.632219;,
0.480982;0.201799;,
0.588354;0.216122;,
0.510644;0.291171;,
0.549087;0.275005;,
0.736312;0.304531;,
0.512073;0.727393;,
0.478594;0.822325;,
0.546184;0.740863;,
0.587236;0.873261;,
0.562766;0.813660;,
0.725542;0.781449;,
0.730128;0.726493;,
0.827220;0.385691;,
0.782338;0.410762;,
0.570779;0.499833;,
0.609959;0.499374;,
0.850152;0.494213;,
0.800686;0.497585;,
0.838664;0.632219;,
0.791481;0.608154;,
0.696563;0.320285;,
0.602559;0.321567;,
0.534729;0.229445;,
0.597693;0.724520;,
0.702681;0.717416;,
0.543456;0.787503;,
0.739025;0.418115;,
0.655138;0.499291;,
0.756135;0.499080;,
0.747623;0.601325;,
0.283058;0.875169;,
0.209662;0.954698;,
0.080795;0.980525;,
0.316727;0.906657;,
0.355448;0.956301;,
0.359596;0.983590;,
0.305437;0.041576;,
0.194000;0.070005;,
0.080578;0.043970;,
0.302303;0.068853;,
0.300600;0.126056;,
0.273314;0.145310;,
0.613619;0.082755;,
0.598386;0.108414;,
0.468843;0.307294;,
0.433539;0.317912;,
0.843832;0.206085;,
0.814520;0.224203;,
0.611384;0.911582;,
0.627286;0.936817;,
0.438893;0.703787;,
0.474769;0.713160;,
0.805716;0.809569;,
0.834415;0.828087;,
0.954648;0.364360;,
0.918581;0.372830;,
0.519686;0.500600;,
0.481723;0.501105;,
0.981417;0.491036;,
0.943827;0.492298;,
0.968032;0.651817;,
0.931195;0.644036;,
0.371575;0.922174;,
0.371575;0.922174;,
0.316727;0.906657;,
0.370675;0.922352;,
0.370675;0.922352;,
0.370675;0.922352;,
0.209662;0.954698;,
0.371575;0.922174;,
0.335270;0.105544;,
0.335270;0.105544;,
0.575255;0.147379;,
0.510644;0.291171;,
0.733415;0.251714;,
0.587236;0.873262;,
0.370675;0.922352;,
0.512073;0.727394;,
0.725542;0.781450;,
0.827219;0.385691;,
0.570779;0.499833;,
0.850152;0.494213;,
0.838663;0.632219;,
0.480982;0.201799;,
0.588354;0.216122;,
0.549087;0.275005;,
0.510644;0.291171;,
0.736311;0.304530;,
0.512073;0.727394;,
0.478594;0.822325;,
0.546184;0.740863;,
0.562766;0.813660;,
0.587236;0.873262;,
0.730128;0.726493;,
0.725542;0.781450;,
0.827219;0.385691;,
0.782338;0.410762;,
0.609959;0.499374;,
0.570779;0.499833;,
0.850152;0.494213;,
0.800685;0.497585;,
0.838663;0.632219;,
0.791481;0.608154;,
0.767663;0.032936;,
0.767663;0.130600;,
0.968885;0.032936;,
0.968885;0.130600;;
}
}
 }
