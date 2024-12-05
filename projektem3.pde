PImage img;                 // A betöltött kép
PImage selection;           // A kijelölt terület másolata
int startX, startY;         // A kijelölés kezdőpontja
int endX, endY;             // A kijelölés végpontja
int duration = 0;           // Az aktuális fázis ideje
int phase = 0;              // Az aktuális fázis számlálója
float dx, dy;               // A kijelölt terület mozgásának irányvektora
int timeElapsed = 0;        // Az időzítéshez eltelt idő követése
PGraphics canvas;           // Egy külön réteg a nyomok tárolására

boolean moving = false;     // Mozgás állapotának figyelése

void setup() {
  size(800, 600);
  img = loadImage("tablazat.png"); // Cseréld ki a megfelelő képnévre
  canvas = createGraphics(width, height); // Nyomok tárolására szolgáló réteg
  
  // A nyomokat tároló réteg kezdeti állapota az eredeti kép másolata
  canvas.beginDraw();
  canvas.image(img, 0, 0); // A háttérkép bemásolása a rétegbe
  canvas.endDraw();
}

int frame = 0;
void draw() {
  // A fő rajzot a `canvas` rétegből és a háttérképből építjük
  image(canvas, 0, 0); // A `canvas` réteg, amely már tartalmazza a nyomokat
  
  // Fázisok és időzítés kezelése
  if (millis() - timeElapsed > duration) {
    phase++;
    if (phase == 1) {
      duration = 1000;       // 2 mp
      newRandomDirection();
    } else if (phase == 2) {
      duration = 3000;       // 4 mp
      newRandomDirection();
    } else {
      phase = 0;             // Új kör kezdése
      duration = 2000;       // 3 mp
    }
    timeElapsed = millis();
  }
  
  // A kijelölt téglalap mozgatása és hozzáadása a réteghez, ha a mozgás engedélyezett
  if (selection != null && moving) {
    startX += dx;
    startY += dy;

    // A nyomokat a `canvas` réteghez adjuk hozzá
    canvas.beginDraw();
    canvas.image(selection, startX, startY); // A kijelölt területet hozzáadjuk a réteghez
    canvas.endDraw();
    
    // Új irány kis időközönként
    if (frameCount % 15 == 0) {
      newRandomDirection();
    }
    if (frame % 5 == 0){
      saveFrame("img-######.png");
    }
    
  }
}

// Kattintásra véletlenszerű méretű téglalap kijelölése
void mousePressed() {
  // Ha a bal egérgombbal kattintunk, új téglalapot jelölünk ki
  if (mouseButton == LEFT && moving == false) {
    // Véletlenszerű téglalap méret
    int w = int(random(80, 300)); // Véletlenszerű szélesség
    int h = int(random(100, 200)); // Véletlenszerű magasság
    
    // Kijelölés kezdőpontja az egér pozíciója
    startX = mouseX;
    startY = mouseY;
    
    // A kijelölt téglalap rögzítése
    selection = img.get(startX, startY, w, h);
    
    // Véletlenszerű mozgásirány beállítása
    newRandomDirection();
    
    // Mozgás engedélyezése
    moving = true;
  }
  
  // Ha a jobb egérgombbal kattintunk, megállítjuk vagy újraindítjuk a mozgást
  if (mouseButton == RIGHT) {
    moving = !moving;  // A mozgás állapotának váltása (stop / start)
  }
}

// Véletlenszerű mozgásirány generálása
void newRandomDirection() {
  dx = random(-5, 5);  // A sebesség véletlenszerűen változhat -5 és +10 között
  dy = random(-5, 5);  // Ugyanez vertikálisan
}
