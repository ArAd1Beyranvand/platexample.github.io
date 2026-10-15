"""Renders the platexample logo (outlined plate with accent bar) to every platform icon."""
from PIL import Image, ImageDraw

BG, FG, ACCENT = (5, 6, 8), (236, 238, 240), (47, 212, 207)
S = 4096


def render(size, glyph_frac, rounded=True):
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([0, 0, S - 1, S - 1], radius=int(S * 0.22) if rounded else 0, fill=BG)
    w = S * glyph_frac
    h = w * 12 / 30
    x0, y0 = (S - w) / 2, (S - h) / 2
    u = w / 30
    r, b = 2 * u, 1.5 * u
    d.rounded_rectangle([x0, y0, x0 + w, y0 + h], radius=r, fill=FG)
    d.rounded_rectangle([x0 + b, y0 + b, x0 + w - b, y0 + h - b], radius=max(r - b, 0.5 * u), fill=BG)
    d.rectangle([x0 + b, y0 + b, x0 + b + 6 * u - b, y0 + h - b], fill=ACCENT)
    return img.resize((size, size), Image.LANCZOS)


def save(path, size, frac=0.66, rounded=True):
    render(size, frac, rounded).save(path)


if __name__ == "__main__":
    save("favicon.png", 64); save("web/favicon.png", 64)
    for d in ("icons", "web/icons"):
        save(f"{d}/Icon-192.png", 192); save(f"{d}/Icon-512.png", 512)
        save(f"{d}/Icon-maskable-192.png", 192, 0.5, False); save(f"{d}/Icon-maskable-512.png", 512, 0.5, False)
    for n, s in dict(mdpi=48, hdpi=72, xhdpi=96, xxhdpi=144, xxxhdpi=192).items():
        save(f"android/app/src/main/res/mipmap-{n}/ic_launcher.png", s)
    save("linux/runner/resources/app_icon.png", 256)
