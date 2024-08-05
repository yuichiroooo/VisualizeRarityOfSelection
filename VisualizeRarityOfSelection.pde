int num_of_tasks  = 10000000;

// 実験の選択肢の数
int num_of_choices = 4;

// 実験のN数
int num_of_trials = 1695;

// 1%を何分割して表示するか（N数/100の値だときれいになる）
int num_of_unit_1percent = 17; // 1695なら16.95で17

// それをどの大きさで表示するか
int x_unit_size = 4;
// 全体で何%から何%まで表示するか
int min_x_percent = 10;
int max_x_percent = 35;

float calcSelectionRate(int num_of_selection, int num_of_trials)
{
  int count = 0;
  for (int i = 0; i < num_of_trials; i++) {
    if ((int)random(num_of_selection) == 0) {
      count++;
    }
  }
  return (float)count * 100 / num_of_trials;
}

void setup() 
{
  size(2000, 900);
  background(255);
  int[] graph_unit = new int[num_of_unit_1percent * 100];
  for (int i=0; i<graph_unit.length; i++) graph_unit[i] = 0;

  // 閾値の設定
  int[]threshold = new int [4];
  // 両側1%
  threshold[0] = (num_of_tasks * 1 / 200);
  threshold[1] = (num_of_tasks * 1 / 40);
  // 両側5%
  threshold[2] = (num_of_tasks * 39 / 40);
  threshold[3] = (num_of_tasks * 199 / 200);

  // 軸情報を表示
  textSize(20);
  fill(0);
  for (int i = min_percent; i <= max_x_percent; i++) {
    int x = (i - min_percent) * x_unit_size * num_of_unit_1percent;
    text(int(i), x + 10, 50);
    stroke(100);
    line(x, height, x, 0);
  }

  // ひたすら実施
  for (int i = 0; i < num_of_tasks; i++) {
    int xid = int(calcSelectionRate(num_of_choices, num_of_trials) * num_of_unit_1percent);
    graph_unit[xid]++;
    // 進捗を提示
    if((i % (num_of_tasks/10)) == 0) println("#" + i);
  }

  // 縦軸の調整のために最大値を求める
  int maxHeight = graph_unit[0];
  for (int i = 0; i < graph_unit.length; i++) {
    if(maxHeight < graph_unit[i]) maxHeight = graph_unit[i];
  }
  
  int total = 0;
  int cur_th = 0;
  for (int i = 0; i < graph_unit.length; i++) {
    // 色つけのために利用。実をいうと閾値ギリギリのところはこれじゃあかん気がする
    if ( cur_th < 4 && total < threshold[cur_th] && threshold[cur_th] < total + graph_unit[i] ) {
      cur_th++;
    }
    // 閾値ごとの色を設定
    if (cur_th == 0) fill(255, 100, 100);
    else if (cur_th == 1) fill(255, 220, 220);
    else if (cur_th == 2) fill(220, 220, 220);
    else if (cur_th == 3) fill(220, 220, 255);
    else fill(100, 100, 255);
    // 描画するで
    if((i / num_of_unit_1percent) >= min_x_percent && (i / num_of_unit_1percent) >= max_x_percent){
      int x = (i - min_x_percent * num_of_unit_1percent) * x_unit_size;
      rect(x, height, x_unit_size, -graph_unit[i] * ((float)height * 0.9 / maxHeight));
      total += graph_unit[i];
    }
  }

  // 結果を表示
  textSize(128);
  fill(100, 100, 255);
  text(num_of_choices + " choices", width/2, 170);
  text("N = " + num_of_trials, width/2, 300);
  textSize(64);
  text("(" + num_of_tasks + " times)", width/2, 380); 
  // 画像として保存
  save(num_of_trials+".png");
}
