#!/usr/bin/python

from algorithm import *
import json
import urllib2
import urllib

debug = False 

class Client:
  findUrl = ("http://localhost:%s/v3/name/find?%s"
             "&user_country_site=%s&geo_country_code=%s"
             "&pagination_size=%d"
             "&pagination_start=0&max_price=2147483647&min_price=0"
             "&max_sld_length=2147483647&min_sld_length=1"
             "&user_shopper_status=PUBLIC""&server_private_label_id=1"
             "&server_currency=USD&server_ip=127.0.0.1"
             "&server_name=anonymous&domain_source=ALL"
             "&user_vguid=strange-visitor-session-ID"
             "&user_shopper_id=%s")

  user2ID = {
    "new"     : "52563262",
    "repeated": "5847060",
    "unknown" : "",
  }

  def __init__(self, port, topN):
    self._port   = port
    self._topN   = topN

  def fetchSerp(self, valueDict):
    key = valueDict["key"]
    country, geo = valueDict["country"], valueDict["geo"]
    city = valueDict["city"]
    query = valueDict["query"]
    user = valueDict["user"]
    date = valueDict["date"]
    longitude, latitude = valueDict["longitude"], valueDict["latitude"]

    querytext = Client.findUrl %(self._port,
                                 urllib.urlencode({"q": query}),
                                 country, geo, self._topN,
                                 Client.user2ID[user])
    if longitude is not None and latitude is not None:
      querytext += "&geo_longitude=%s&geo_latitude=%s" %(longitude, latitude)
    if city is not None:
      querytext += "&geo_city=%s" %(urllib.quote(city))
    extraInf = []   
    if key is not None:
      extraInf.append("key:" + key)
    if date is not None:
      extraInf.append("date:" + date)
    if extraInf != []:
      querytext += "&query_info=" + ";".join(extraInf)

    print querytext, "\n"

    request = urllib2.Request(querytext)
    handler = urllib2.urlopen(request)
    jasonResult = json.loads(handler.read())

    domains = jasonResult["domains"]
    segs = jasonResult["keys"]
    summary = {}
    results = [["ID", "Inventory", "Match", "Source",
                  "Ext", "SLD", "Domain", "Score"]]
    for b in domains :
      display = []
      display.append(str(b["index"]))
      if b["inventory"] == "extensions" :
        display.append("ext")
        summary["ext"] = summary.get("ext",0) + 1
      elif b["inventory"] == "ccTLDfar" :
        display.append("cFar")
        summary["cFar"] = summary.get("cFar",0) + 1
      elif b["inventory"] == "ccTLDspin" :
        display.append("cSpin")
        summary["cSpin"] = summary.get("cSpin",0) + 1
      elif b["inventory"] == "ccTLDextended" :
        display.append("cExt")
        summary["cExt"] = summary.get("cExt",0) + 1
      else :
        display.append(b["inventory"])
        summary[b["inventory"]] = summary.get(b["inventory"],0) + 1

      if  b.has_key("match_source")  :
        display.append(b["match_source"])
      else :
        display.append("")

      if  b["domain_source"] == "cctld" :
        display.append(b["domain_source"] + "\t")
      elif b["domain_source"] == "premium" :
        display.append(b["domain_source"] + "\t")
      else :
        display.append(b["domain_source"])

      tld = b["extension"]
      if len(tld) <= 7 :
        display.append(b["extension"] + "\t")
      else :
        display.append(b["extension"])

      sld = b["name_without_extension"]
      if len(sld) <= len(query) :
        for i in range(len(sld),len(query)) :
          sld = sld + " "
      display.append(sld)

      name=b["fqdn"]
      if len(name) <= (len(query) + 9) : ## pad space
        for i in range(len(name),len(query) + 9) :
          name = name + " "
      display.append(name)
      try:
        display.append(str(round(b["domain_score"], 10)))
      except:
        display.append("Null")

      assert len(display) == 8
      display = map(methodcaller("strip"), display)
      results.append(display)

    return jasonResult["diagnostic"], segs, summary, results

  def beautifulPrint(self, results):
    fieldNum = len(results[0])
    fieldWidth = [max(len(item[fid]) for item in results)
                  for fid in xrange(fieldNum)]
    for itemID, item in enumerate(results):
      for fid, field in enumerate(item):
        if field.strip() == "":
          field = "none"
        print field.ljust(fieldWidth[fid] + 2),
      print
      if itemID % 10 == 0:
        print

if __name__ == "__main__":
  parser = OptionParser(usage = "cmd [optons] ..]")
  #parser.add_option("-q", "--quiet", action = "store_true", dest = "verbose", \
      #default = False, help = "don"t print status messages to stdout")
  parser.add_option("--port", dest = "port", default = "8080",
                    help = "default '8080'")
  parser.add_option("-n", dest = "topN", type = int, default = 20,
                    help = "20 by default")
  parser.add_option("--country", dest = "country", default = "www",
                    help = "default 'www'")
  parser.add_option("--geo", dest = "geo", default = "us",
                    help = "default 'us'")
  parser.add_option("--long", dest = "longitude", type = float, default = None)
  parser.add_option("--lat", dest = "latitude", type = float, default = None)
  parser.add_option("--city", dest = "city", default = None)
  parser.add_option("-q", dest = "query", default = "zoespizza",
                    help = "default 'zoespizza'")
  parser.add_option("--user", dest = "user", default = "new",
                   help = "default 'new'.")
  parser.add_option("--date", dest = "date", default = None)
  parser.add_option("--key", dest = "key", default = None)
  (options, args) = parser.parse_args()

  client = Client(options.port, options.topN)
  valueDict = {
    "key"       : options.key,
    "query"     : options.query,
    "country"   : options.country,
    "geo"       : options.geo,
    "user"      : options.user,
    "longitude" : options.longitude,
    "latitude"  : options.latitude,
    "city"      : options.city,
    "date"      : options.date,
  }
  diag, segs, summary, results = client.fetchSerp(valueDict)
  print "Query: %s, country: %s, geo: %s" %(options.query.lower(),
                                            options.country,
                                            options.geo)
  print "Segmentation:", " ".join(segs)
  print

  client.beautifulPrint(results)
  for key in summary.keys():
    print key + "=" + str(summary[key]) + "  ",
  print "\n"
  print diag

