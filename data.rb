4
	class z_blob : public blob
	[
	  public:
	    z_blob() : blob(Z_BLOB)
	    [
	      orientation data[4] = 
	      [
		[[[0,0],[0,1],[1,1],[1,2]]],
		[[[0,2],[1,1],[1,2],[2,1]]],
		[[[1,1],[1,2],[2,1],[2,2]]],
		[[[0,1],[1,0],[1,1],[2,0]]]
	      ];  
	      set_cell_data(data);
	    ]
	];

	class i_blob : public blob
	[
	  public:
	  i_blob() : blob(I_BLOB)
	  [
	    orientation data[4] = 
	    [
	      [[[0,1],[1,1],[2,1],[3,1]]],
	      [[[1,0],[1,1],[1,2],[1,3]]],
	      [[[0,2],[1,2],[2,2],[3,2]]],
	      [[[2,0],[2,1],[2,2],[2,3]]]
	    ];  
	    set_cell_data(data);
	  ]
	];

	class box_blob : public blob
	[
	  public:
	  box_blob() : blob(BOX_BLOB)
	  [
	    orientation data[4] = 
	    [ 
	      [[[1,1],[1,2],[2,1],[2,2]]],
	      [[[1,1],[1,2],[2,1],[2,2]]],
	      [[[1,1],[1,2],[2,1],[2,2]]],
	      [[[1,1],[1,2],[2,1],[2,2]]],
	    ];  
	    set_cell_data(data);
	  ]
	];

	class l_blob : public blob
	[
	  public:
	  l_blob() : blob(L_BLOB)
	  [
	    orientation data[4] = 
	    [
	      [[[0,0],[1,0],[2,0],[2,1]]],
	      [[[0,0],[0,1],[0,2],[1,0]]],
	      [[[0,1],[0,2],[1,2],[2,2]]],
	      [[[2,0],[2,1],[2,2],[1,2]]]
	    ];  
	    set_cell_data(data);
	  ]
	];

	class r_blob : public blob
	[
	  public:
	  r_blob() : blob(R_BLOB)
	  [
	    orientation data[4] = 
	    [
	      [[[0,0],[0,1],[1,0],[2,0]]],
	      [[[0,0],[0,1],[0,2],[1,2]]],
	      [[[0,2],[1,2],[2,2],[2,1]]],
	      [[[1,0],[2,0],[2,1],[2,2]]]
	    ];  
	    set_cell_data(data);
	  ]
	];


end60135
