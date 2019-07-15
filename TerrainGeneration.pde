final int scale = 10;
final int w = 1600;
final int h = 1600;

final int MIN_HEIGHT = -100;
final int MAX_HEIGHT = 100;

final float NOISE_X_STEP = 0.05;
final float NOISE_Y_STEP = 0.05;

final color MIN_COLOR = color(0, 0, 255);
final color MAX_COLOR = color(255, 0, 0);

int cols, rows;
float flying = 0.0;

float[][] heightMap;

void setup() {
    size(600, 600, P3D);
    frameRate(30);
    
    cols = w / scale;
    rows = h / scale;
    heightMap = new float[rows][cols];
}

void draw() {
    flying -= 0.1;
    float yOffset = flying;
    for (int y = 0; y < rows; y++) {
        float xOffset = 0.0;
        for (int x = 0; x < cols; x++) {
            // Use Perlin Noise to generate the height map
            heightMap[y][x] = map(noise(xOffset, yOffset), 0, 1, MIN_HEIGHT, MAX_HEIGHT);
            xOffset += NOISE_X_STEP;
        }
        yOffset += NOISE_Y_STEP;
    }
    
    background(135, 206, 235);
    noStroke();
    
    translate(width / 2, height / 2);
    rotateX(PI / 3);
    translate(-w / 2, -h / 2);
    
    for (int y = 0; y < rows - 1; y++) {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < cols - 1; x++) {
            color c = lerpColor(MIN_COLOR, MAX_COLOR, map(heightMap[y][x], MIN_HEIGHT, MAX_HEIGHT, 0, 1));
            fill(c);
            vertex(x * scale, y * scale, heightMap[y][x]);
            vertex(x * scale, (y + 1) * scale, heightMap[y + 1][x]);
            vertex((x + 1) * scale, y * scale, heightMap[y][x + 1]);
            vertex((x + 1) * scale, (y + 1) * scale, heightMap[y + 1][x + 1]);
        }
        endShape();
    }
}
