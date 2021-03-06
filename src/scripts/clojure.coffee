# Evaluate one line of Clojure script.
#
# clojure|clj <script> - Evaluate one line of Clojure script
module.exports = (robot) ->
  robot.respond /(clojure|clj)\s+(.*)/i, (msg)->
    script = encodeURIComponent(msg.match[2])

    msg.http("http://tryclj.com/eval.json?expr=#{script}")
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            result = JSON.parse(body)

            if result.error
              msg.reply result.message
            else
              outputs = result.result.split("\n")
              for output in outputs
                msg.reply output
          else
            msg.reply "Unable to evaludate script: #{script}. Request returned with the status code: #{res.statusCode}"
