for i in range(99):
	old = open("../analyze_{num}.json".format(num = i), "r");
	lines = old.readlines();
	lines = lines[:-1];
	old.close();

	new = open("../analyze_{num}.json".format(num = i), "w");
	for line in lines:
		new.write(line);

	new.close();
# 
