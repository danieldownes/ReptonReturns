xof 0303txt 0032
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


Frame Scene_Root {
 

 FrameTransformMatrix {
  1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000;;
 }

 Frame Dimond {
  

  FrameTransformMatrix {
   1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,-0.481928,-0.481928,51.777164,1.000000;;
  }

  Frame Pyramid02 {
   

   FrameTransformMatrix {
    -1.000000,0.000000,-0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,-1.000000,0.000000,0.000000,0.000000,0.000000,1.000000;;
   }

   Frame {
    

    FrameTransformMatrix {
     1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,-0.000000,1.000000;;
    }

    Mesh {
     12;
     0.000000;0.000000;51.874699;,
     -29.397591;-29.879519;0.000000;,
     29.397591;-29.879519;0.000000;,
     29.397591;29.879519;0.000000;,
     -29.397591;29.879519;0.000000;,
     0.000000;0.000000;51.874699;,
     29.397591;-29.879519;0.000000;,
     0.000000;0.000000;51.874699;,
     29.397591;29.879519;0.000000;,
     0.000000;0.000000;51.874699;,
     -29.397591;29.879519;0.000000;,
     -29.397591;-29.879519;0.000000;;
     4;
     3;0,1,2;,
     3;5,6,3;,
     3;7,8,4;,
     3;9,10,11;;

     MeshNormals {
      12;
      0.000000;-0.866534;0.499118;,
      0.000000;-0.866534;0.499118;,
      0.000000;-0.866534;0.499118;,
      0.870008;0.000000;0.493037;,
      0.000000;0.866534;0.499118;,
      0.870008;0.000000;0.493037;,
      0.870008;0.000000;0.493037;,
      0.000000;0.866534;0.499118;,
      0.000000;0.866534;0.499118;,
      -0.870008;0.000000;0.493037;,
      -0.870008;0.000000;0.493037;,
      -0.870008;0.000000;0.493037;;
      4;
      3;0,1,2;,
      3;5,6,3;,
      3;7,8,4;,
      3;9,10,11;;
     }

     VertexDuplicationIndices {
      12;
      5;
      0,
      1,
      2,
      3,
      4,
      0,
      2,
      0,
      3,
      0,
      4,
      1;
     }

     MeshMaterialList {
      1;
      4;
      0,
      0,
      0,
      0;

      Material {
       0.964706;0.811765;0.196078;0.900000;;
       0.000000;
       0.900000;0.900000;0.900000;;
       0.000000;0.000000;0.000000;;
      }
     }
    }
   }
  }

  Frame Pyramid01 {
   

   FrameTransformMatrix {
    1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000;;
   }

   Frame {
    

    FrameTransformMatrix {
     1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000;;
    }

    Mesh {
     12;
     0.000000;0.000000;51.874699;,
     -29.397591;-29.879519;0.000000;,
     29.397591;-29.879519;0.000000;,
     29.397591;29.879519;0.000000;,
     -29.397591;29.879519;0.000000;,
     0.000000;0.000000;51.874699;,
     29.397591;-29.879519;0.000000;,
     0.000000;0.000000;51.874699;,
     29.397591;29.879519;0.000000;,
     0.000000;0.000000;51.874699;,
     -29.397591;29.879519;0.000000;,
     -29.397591;-29.879519;0.000000;;
     4;
     3;0,1,2;,
     3;5,6,3;,
     3;7,8,4;,
     3;9,10,11;;

     MeshNormals {
      12;
      0.000000;-0.866534;0.499118;,
      0.000000;-0.866534;0.499118;,
      0.000000;-0.866534;0.499118;,
      0.870008;0.000000;0.493037;,
      0.000000;0.866534;0.499118;,
      0.870008;0.000000;0.493037;,
      0.870008;0.000000;0.493037;,
      0.000000;0.866534;0.998237;,
      0.000000;0.000000;0.499118;,
      -0.870008;0.900000;1.393037;,
      -0.870008;0.000000;0.493037;,
      -0.870008;0.000000;0.493037;;
      4;
      3;0,1,2;,
      3;5,6,3;,
      3;7,8,4;,
      3;9,10,11;;
     }

     VertexDuplicationIndices {
      12;
      5;
      0,
      1,
      2,
      3,
      4,
      0,
      2,
      0,
      3,
      0,
      4,
      1;
     }

     MeshMaterialList {
      1;
      4;
      0,
      0,
      0,
      0;

      Material {
       0.964706;0.811765;0.196078;0.900000;;
       0.000000;
       0.900000;0.900000;0.900000;;
       0.000000;0.000000;0.000000;;
      }
     }
    }
   }
  }
 }

 Frame Gound {
  

  FrameTransformMatrix {
   1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,-0.481928,0.000000,0.000000,1.000000;;
  }
 }
}