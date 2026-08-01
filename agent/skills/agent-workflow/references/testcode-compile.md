# java-interview-drills compile and run

Local path: `C:\Projects\java-interview-drills`  
GitHub: https://github.com/dhelman999/java-interview-drills

**Never** run bare `javac` from `src/` — that drops `.class` files next to `.java` sources.

Always compile into `out/classes` (gitignored):

```powershell
# Preferred: project script
& C:\Projects\java-interview-drills\scripts\compile-and-run.ps1 leetcode.lru.LruCacheSentinelTest `
    leetcode/lru/LruCacheSentinelSolution.java `
    leetcode/lru/LruCacheSentinelTest.java

# Or explicit javac/java
$out = "C:\Projects\java-interview-drills\out\classes"
New-Item -ItemType Directory -Force -Path $out | Out-Null
javac -d $out -sourcepath C:\Projects\java-interview-drills\src <sources...>
java -cp $out <main.class>
```

If `.class` files appear under `src/`, delete them after fixing the compile command.

Cloud: GitHub Actions workflow `.github/workflows/ci.yml` compiles everything and runs the drill tests on `main`.

Java formatting: skill `java-coding-style` (Spring-aligned, 4 spaces).  
Reference solution: `C:\Projects\java-interview-drills\src\leetcode\lru\LruCacheSentinelSolution.java`
