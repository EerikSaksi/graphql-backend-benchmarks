import json
import matplotlib.pyplot as plt
poggers = json.load(open("./results/poggers_report.json"))
hasura = json.load(open("./results/hasura_report.json"))
postgraphile = json.load(open("./results/postgraphile_report.json"))

for query in ["AlbumsTracksGenreAll", "AlbumsTracksGenreSome", "TracksMediaAll", "ArtistByArtistId"]:
    plt.title("Request capacities for " + query)
    plt.xlabel('Technology used')
    plt.ylabel('Mean request/second capacity over 60 seconds')
    avg =  next(item for item in poggers if item["name"] == query + "-k6-60s-max-requests")["requests"]["average"]
    plt.bar("Poggers", avg)
    avg = next(item for item in hasura if item["name"] == query + "-k6-60s-max-requests")["requests"]["average"]
    plt.bar("Hasura", avg)
    avg = next(item for item in postgraphile if item["name"] == query + "-k6-60s-max-requests")["requests"]["average"]
    plt.bar("Postgraphile", avg)
    plt.legend()
    plt.savefig("plots/" + query + ".png")
    plt.clf()
