int num_of_times  = 10000000;

// 実験の選択肢の数
int num_of_choices = 6;

// 先行表示の試行数と縦線を引きたい選択率
int num_of_trials_of_preceding = 4446;
int preceding_rate = 18;

// 遅延表示の試行数と縦線を引きたい選択率
int num_of_trials_of_delay = 4358;
int delay_rate = 16;

// 1%を何分割して表示するか（N数/100の値だときれいになる）
int num_of_unit_1percent = 44;

// それをどの大きさで表示するか
int x_unit_size = 4;

// 全体で何%から何%まで表示するか
int min_x_percent = 14;
int max_x_percent = 19;

int windowHeight = 600;
int windowWidth; // 横幅は自動で決まる

int[] graph_unit;

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
  int windowWidth = (max_x_percent - min_x_percent + 1) * num_of_unit_1percent * x_unit_size;
  surface.setResizable(false);
  surface.setSize(windowWidth, windowHeight);
  graph_unit = new int[num_of_unit_1percent * 100 + 1];
  for (int i = 0; i < graph_unit.length; i++) graph_unit[i] = 0;

  // ひたすら実施
  for (int i = 0; i < num_of_times; i++) {
    // 先行・遅延に応じてtrialsを変える
    int xid = int(calcSelectionRate(num_of_choices, num_of_trials_of_preceding) * num_of_unit_1percent);
    graph_unit[xid]++;
    // 進捗を提示
    if((i % (num_of_times/10)) == 0) println("#" + i);
  }
}

void draw(){
  background(255);
  
  // 軸情報を表示
  textSize(20);
  fill(0);

  for (int p = min_x_percent; p <= max_x_percent; p++) {
    int x = (p - min_x_percent) * x_unit_size * num_of_unit_1percent;
    textSize(35);
    text(int(p) + "%", x + 10, 50);
    line(x, height, x, 0);
  }

  strokeWeight(1);
  stroke(0);

  // 縦軸の調整のために最大値を求める
  int maxHeight = graph_unit[0];
  for (int i = 0; i < graph_unit.length; i++) {
    if(maxHeight < graph_unit[i]) maxHeight = graph_unit[i];
  }

  // 閾値の設定
  int[] threshold = new int[2];
  // 片側1%（両側2%）
  threshold[0] = (num_of_times * 1 / 100);
  threshold[1] = (num_of_times * 99 / 100);
  
  int total = 0;
  int cur_th = 0;

  for (int i = 0; i < graph_unit.length; i++) {
    // 色つけのために利用。実をいうと閾値ギリギリのところはこれじゃあかん気がする
    if ( cur_th < 2 && total < threshold[cur_th] && threshold[cur_th] < total + graph_unit[i] ) {
      cur_th++;
    }
    
    // 閾値ごとの色を設定
    if (cur_th == 0) fill(255, 100, 100);
    else if (cur_th == 1) fill(220, 220, 220);
    else fill(255, 100, 100);

    // 描画するで
    if((i / num_of_unit_1percent) >= min_x_percent && (i / num_of_unit_1percent) <= max_x_percent){
      int x = (i - min_x_percent * num_of_unit_1percent) * x_unit_size;
      rect(x, height, x_unit_size, -graph_unit[i] * ((float)height * 0.9 / maxHeight));
    }
    total += graph_unit[i];
  }
  
  // 任意のa%の位置に青い点線を描画
  float a_percent = (preceding_rate - min_x_percent) * x_unit_size * num_of_unit_1percent;
  stroke(0, 0, 255);
  strokeWeight(4);
  line(a_percent, 0, a_percent, height);

  // 結果を表示
  textSize(70);
  fill(0, 0, 255);
  String formattedTrials = nf(num_of_trials_of_preceding, 0).replaceAll("(\\d)(?=(\\d{3})+$)", "$1,");
  text("N = " + formattedTrials, width/2 - 480, 300);
  
  // 画像を囲む枠線
  stroke(0);
  strokeWeight(2);
  noFill();
  rect(0, 0, width, height);

  // 画像として保存
  save(num_of_trials_of_preceding+".png");
  noLoop();
}
