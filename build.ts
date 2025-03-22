
async function main() {
    const manifest = JSON.parse(await Bun.file("cursor.json").text())
    const postInstall = await Bun.file("post_install.ps1").text()
    manifest.post_install = postInstall.split(/\r?\n/)
    await Bun.write("cursor.json", JSON.stringify(manifest, null, 2))
}

main()