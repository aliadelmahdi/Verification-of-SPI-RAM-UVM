import os

script_dir = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.dirname(script_dir)

root_dirs = [
    os.path.join(root_dir, "top"),
    os.path.join(root_dir, "design"),
    os.path.join(root_dir, "objects"),
    os.path.join(root_dir, "interface")
]

output_file = "scripts/incdirs.f"
extensions = {".sv", ".svh", ".v"}
incdirs = set()
source_files = []

for root_dir in root_dirs:
    if os.path.isdir(root_dir):
        for dirpath, dirnames, filenames in os.walk(root_dir):
            relative_dir = os.path.relpath(dirpath, root_dir)
            relative_dir = relative_dir.replace("\\", "/")
            
            if relative_dir == ".":
                incdirs.add(f"+incdir+./{os.path.basename(root_dir)}")
            else:
                incdirs.add(f"+incdir+./{os.path.basename(root_dir)}/{relative_dir}")
            
            for file in filenames:
                if os.path.splitext(file)[1] in extensions:
                    file_path = os.path.relpath(os.path.join(dirpath, file), root_dir)
                    file_path = file_path.replace("\\", "/")
                    source_files.append(file_path)

with open(output_file, "w") as f:
    f.write("// This file was automatically generated by the script 'find_files.py'\n")
    for inc in sorted(incdirs):
        f.write(inc + "\n")
    f.write("// Enviroment source files\n")
    for src in sorted(source_files):
        f.write(src + "\n")