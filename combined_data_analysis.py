import json
import matplotlib.pyplot as plt
import os


x = ["{}/{}".format(i, 16 - i)  for i in range(1,16)]
for query in ["AlbumsTracksGenreAll", "AlbumsTracksGenreSome", "TracksMediaAll", "ArtistByArtistId"]:
    poggers_averages = []
    hasura_averages = []
    postgraphile_averages = []
    for server_cpus in range(1,16):
        db_cpus = 16 - server_cpus
        results_dir = "results/{}_server_cpus_{}_db_cpus/".format(server_cpus, db_cpus)
        poggers = json.load(open(results_dir + "poggers_report.json"))
        hasura = json.load(open(results_dir + "hasura_report.json"))
        postgraphile = json.load(open(results_dir + "postgraphile_report.json"))
        poggers_averages.append(next(item for item in poggers if item["name"] == query + "-k6-60s-max-requests")["requests"]["average"])
        hasura_averages.append(next(item for item in hasura if item["name"] == query + "-k6-60s-max-requests")["requests"]["average"])
        postgraphile_averages.append(next(item for item in postgraphile if item["name"] == query + "-k6-60s-max-requests")["requests"]["average"])

    plt.title("Mean Request Capacities for " + query)
    plt.xlabel('Allocated Server CPUs/Database CPUs')
    plt.ylabel('Mean request/second capacity over 60 seconds')
    plt.plot(x, poggers_averages, label = "poggers")
    plt.plot(x, hasura_averages, label = "Hasura")
    plt.plot(x, postgraphile_averages, label = "Postgraphile")
    plt.xticks(rotation = 40)
    plt.gcf().subplots_adjust(bottom=0.15)
    plt.gca().legend()
    plt.savefig("plots/" + query + ".png")
    plt.clf()
