import json
import matplotlib.pyplot as plt
import os

poggers_averages = []
hasura_averages = []
postgraphile_averages = []
for db_cpus in range(1,3):
    server_cpus = 16 - db_cpus
    results_dir = "results/{}_server_cpus_{}_db_cpus/".format(server_cpus, db_cpus)
    poggers = json.load(open(results_dir + "poggers_report.json"))
    hasura = json.load(open(results_dir + "hasura_report.json"))
    postgraphile = json.load(open(results_dir + "postgraphile_report.json"))
    poggers_averages.append(next(item for item in poggers if item["name"] == "AlbumsTracksGenreAll-k6-60s-max-requests")["requests"]["average"])
    hasura_averages.append(next(item for item in hasura if item["name"] == "AlbumsTracksGenreAll-k6-60s-max-requests")["requests"]["average"])
    postgraphile_averages.append(next(item for item in postgraphile if item["name"] == "AlbumsTracksGenreAll-k6-60s-max-requests")["requests"]["average"])

plt.plot([15 / 1, 14 / 2], poggers_averages, label = "poggers")
plt.plot([15 / 1, 14 / 2], hasura_averages, label = "Hasura")
plt.plot([15 / 1, 14 / 2], postgraphile_averages, label = "Postgraphile")
plt.gca().legend()
plt.savefig("cool.png")
