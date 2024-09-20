const rl = @import("raylib");

//general structs in which the player and enemy will inherit from
const My_Rectangle = struct {
    x: i32,
    y: i32,
    width: i32,
    height: i32,
    color: rl.Color,
    pub fn init(x: i32, y: i32, widht: i32, height: i32, color: rl.Color) My_Rectangle {
        return My_Rectangle{ .x = x, .y = y, .width = widht, .height = height, .color = color };
    }
    pub fn draw_rec(self: My_Rectangle) !void {
        rl.drawRectangle(self.x, self.y, self.width, self.height, self.color);
    }
};

//ball struct
const Ball = struct {
    x: i32,
    y: i32,
    radius: f32,
    color: rl.Color,
    Dx: i32,
    Dy: i32,
    pub fn init(x: i32, y: i32, radius: f32, color: rl.Color, Dx: i32, Dy: i32) Ball {
        return Ball{
            .x = x,
            .y = y,
            .radius = radius,
            .color = color,
            .Dx = Dx,
            .Dy = Dy,
        };
    }

    pub fn draw_circle(self: Ball) !void {
        rl.drawCircle(self.x, self.y, self.radius, self.color);
    }
    pub fn update_pos(self: *Ball, screenHeight:comptime_int, screenWidth:comptime_int) !void {
        self.x += self.Dx;
        self.y += self.Dy;
        if (self.y + self.radius >= screenHeight || self.y - self.radius <= 0) {self.Dy *= -1;} else {}
    }
};

pub fn main() anyerror!void {
    const screenWidth = 1000;
    const screenHeight = 1050;

    var player = My_Rectangle.init(screenWidth / 2 - 225, 1000, 450, 50, rl.Color.white);
    var ball = Ball.init(screenWidth / 2, screenHeight / 2, 40.0, rl.Color.pink, 7, 7);

    rl.initWindow(screenWidth, screenHeight, "Breakout");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        try ball.update_pos();
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        rl.drawFPS(0, 0);
        try player.draw_rec();
        try ball.draw_circle();
    }
}
