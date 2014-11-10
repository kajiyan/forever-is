var afterThat = [
  {
    offset: 0, // (int) 現在の再生位置
    size: 0,   // (int) アニメーションのトータルフレーム
    position: [
      {
        x: 0,
        y: 0,
        date: "Wednesday 05 November 2014 9:18:17"
      }
    ]
  }
];

console.log(afterThat);

if (afterThat[0].offset <= afterThat[0].size) {
  afterThat[0].position[afterThat[0].offset].x;
  afterThat[0].position[afterThat[0].offset].y;
  afterThat[0].position[afterThat[0].offset].date;

  // for(var i = 0; i <= afterThat[0].size){

  // };

  afterThat[0].offset++;
};