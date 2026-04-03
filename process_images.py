import os
from rembg import remove

icons = [
    "assets/icons/new_role_student.jpg",
    "assets/icons/new_role_admin.jpg",
    "assets/icons/new_role_parent.jpg",
    "assets/icons/new_role_staff.png"
]

for file_path in icons:
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
    with open(file_path, 'rb') as i:
        input_data = i.read()
    output_data = remove(input_data)
    
    out_path = file_path.rsplit('.', 1)[0] + "_transparent.png"
    with open(out_path, 'wb') as o:
        o.write(output_data)
    print(f"Processed {file_path} -> {out_path}")
