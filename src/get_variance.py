from names_generator import generate_name



i = 0
total_count = 0
greater_one = 0
equal_one = 0
all_counts = set()
names = {}

print(generate_name(style="capital"))

for x in range(500000):
    i += 1
    name = generate_name()
    if name not in names.keys():
        names[name] = 0
    names[name] += 1
for name, count in names.items():
    total_count += count
    if count == 1:
        equal_one += 1
    elif count > 1:
        greater_one += 1
    all_counts.add(count)
print(f"{i}/{total_count}")

print(f"{len(names)}: {greater_one} names were generated more than once\n"
      f"{equal_one} generated once. {sorted(all_counts, reverse=True)}")
