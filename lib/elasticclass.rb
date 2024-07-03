class ElasticClass
    include Elasticsearch 
    @ca_fingerprint = "74:49:1F:E1:3E:0D:CF:5B:D5:B6:29:69:A2:B1:E9:3D:50:E4:27:2E:F5:46:55:B7:4B:BA:9B:A3:4C:30:17:A5"
    @api_key = "eWZxWDZvOEJlVFBoR0lmYWM3MVQ6UlQ0dXRmeTlRUGFYLW5sd0JVQVVMQQ=="
    @host = "https://elastic.chunkysports.com:9200"

    @query1 = <<TEXT
  "query": {
    "bool": {
      "must": {
        "multi_match": {
          "query": "{SEARCHTERM}",
          "fields": ["title", "description"]
        }
      },
      "filter": {
        "terms": {
          "source_id": {SOURCE_IDS}
        }
      }
    }
  },
  "sort": [
    {
      "created_at": {
        "order": "desc"
      }
    }
  ]
}
TEXT

@query2 =<<TEXT
{
  "query": {
    "bool": {
      "must": {
        "multi_match": {
          "query": "{SEARCHTERM}",
          "fields": ["title", "description"]
        }
      },
      "filter": [
        {
          "terms": {
            "source_id": {SOURCE_IDS}
          }
        },
        {
          "term": {
            "youtube": true
          }
        }
      ]
    }
  },
  "sort": [
    {
      "created_at": {
        "order": "desc"
      }
    }
  ]
}

TEXT

    
    
  
    def initialize()
      @client = Elasticsearch::Client.new(
        host: "https://elastic:DaBus099@elastic.chunkysports.com:9200",
        transport_options: { ssl: { verify: false } }
      )
    end
  
    def search(id)
      @response = @client.search(index: "lumps", q: id, body: { fields: [{ field: 'id'}]})
      puts @response['hits']['hits'].count
      puts @response      
    end

    def search1(searchtype,searchterm, source_ids, team, video)



case searchtype
when 1
    if video
        query = <<-TEXT
{
        "size": 100,
         "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query": "#{searchterm}",
            "fields": ["title", "description"]
          }
        },
        {
          "term": {
            "youtube": true
          }
        }
      ]
    }
  },
  "sort": [
    {
      "created_at": {
        "order": "desc"
      }
    }
  ]
}

  
TEXT
    
    else
        query = <<-TEXT
{
  "size": 100,
  "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query": "#{searchterm}",
            "type": "phrase",
            "fields": ["title", "description"]
          }
        }

      ]
    }
  },
  "sort": [
    {
      "created_at": {
        "order": "desc"
      }
    }
  ]
}

TEXT

    end #end if video
    


when 2

    if video
query = <<-TEXT
{
  "size": 100,
  "query": {
    "bool": {
      "must": {
        "multi_match": {
         "query": "#{searchterm}",
          "fields": ["title", "description"]
        }
      },
      "filter": [
        {
          "terms": {
            "source_id": #{source_ids}
          }
        },
        {
          "term": {
            "youtube": true
          }
        }
      ]
    }
  },
  "sort": [
    {
      "created_at": {
        "order": "desc"
      }
    }
  ]
}
TEXT


    else
        query = <<-TEXT
        {
                "size": 100,
                "query": {
                  "bool": {
                    "must": {
                      "multi_match": {
                        "query": "#{searchterm}",
                        "type": "phrase",
                        "fields": ["title", "description"]
                      }
                    },
                    "filter": {
                      "terms": {
                        "source_id": #{source_ids}
                      }
                    }
                  }
                },
                "sort": [
                  {
                    "created_at": {
                      "order": "desc"
                    }
                  }
                ]
              }
TEXT
        

    end #end if video

   
when 3
    if video
query = <<-TEXT
{
  "size": 100,
  "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query": "#{searchterm}",
            "fields": ["title", "description"]
          }
        },
        {
          "term": {
            "source_id": #{team}
          }
        },
        {
          "term": {
            "youtube": true
          }
        }
      ]
    }
  },
  "sort": [
    {
      "created_at": {
        "order": "desc"
      }
    }
  ]
}
TEXT
    else
        query = <<-TEXT
{
  "size": 100,
  "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query": "#{searchterm}",
            "fields": ["title", "description"]
          }
        },
        {
          "term": {
            "source_id": #{team}
          }
        }
      ]
    }
  },
  "sort": [
    {
      "created_at": {
        "order": "desc"
      }
    }
  ]
}
TEXT
    
    end #if video


end


     @response = @client.search(index: "lumps", body: query)
   
     
     search1 = @response["hits"]["hits"]

    end
  
  end