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
    pub fn extract_rec(self: My_Rectangle) rl.Rectangle {
        const x: f32 = @floatFromInt(self.x);
        const y: f32 = @floatFromInt(self.y);
        const width: f32 = @floatFromInt(self.width);
        const height: f32 = @floatFromInt(self.height);
        return rl.Rectangle.init(x, y, width, height);
    }
    pub fn update_player(self: *My_Rectangle) !void {
        if (rl.isKeyDown(rl.KeyboardKey.key_a)) {
            self.x -= 10;
        }
        if (rl.isKeyDown(rl.KeyboardKey.key_d)) {
            self.x += 10;
        }
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
    pub fn update_pos(self: *Ball, screenHeight: comptime_int, screenWidth: comptime_int) !void {
        self.x += self.Dx;
        self.y += self.Dy;
        const radius: i32 = @intFromFloat(self.radius);
        if (self.y + radius >= screenHeight) {
            self.Dy *= -1;
        } else if (self.y - radius <= 0) {
            self.Dy *= -1;
        }
        if (self.x + radius >= screenWidth) {
            self.Dx *= -1;
        } else if (self.x - radius <= 0) {
            self.Dx *= -1;
        }
    }
    pub fn extract_circle(self: Ball) rl.Vector2 {
        const x: f32 = @floatFromInt(self.x);
        const y: f32 = @floatFromInt(self.y);
        return rl.Vector2.init(x, y);
    }
};

pub fn main() anyerror!void {
    const screenWidth = 1900;
    const screenHeight = 1050;

    var player = My_Rectangle.init(screenWidth / 2 - 225, 1000, 450, 50, rl.Color.white);
    var ball = Ball.init(screenWidth / 2, screenHeight / 2, 40.0, rl.Color.pink, 7, 7);

    rl.initWindow(screenWidth, screenHeight, "Breakout");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        //update_player and ball positions each frame
        try player.update_player();
        try ball.update_pos(screenHeight, screenWidth);

        //detect collisions
        if (rl.checkCollisionCircleRec(ball.extract_circle(), ball.radius, player.extract_rec())) {
            ball.Dy *= -1;
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        rl.drawFPS(0, 0);
        try player.draw_rec();
        try ball.draw_circle();
    }
}
