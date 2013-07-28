submissions_stream = null
submission_onchange = (e, d) ->
  target = $(this)
  target.prependTo(target.parent()) \
        .css('background-color', 'rgb(242, 242, 145)') \
        .delay(100) \
        .animate({'background-color': 'white'}, 300)

prepare = ->
  if 0 < $(".submission.detailed").length
    if submissions_stream && submissions_stream.url.match(/detailed_stream$/)
      return
    else
      submissions_stream.close() if submissions_stream
      submissions_stream = new EventSource("/submissions/detailed_stream")
  else if  0 < $(".submission").length
    if submissions_stream && !submissions_stream.url.match(/detailed_stream$/)
      return
    else
      submissions_stream.close() if submissions_stream
      submissions_stream = new EventSource("/submissions/stream")

  if submissions_stream
    submissions_stream.addEventListener("submission", (e) ->
      payload = JSON.parse(e.data)
      updated_submission = $(payload.html)
      target = $(".submission_#{payload.submission_id}")
      target.each( ->
        submission = $(this)
        submission.html(updated_submission.html())
        detailed = submission.hasClass('detailed')
        this.className = updated_submission[0].className

        if detailed
          submission.addClass('detailed')
        else
          submission.removeClass('detailed')
      )

      if 0 < target.length
        $(document).add(target).trigger("submissions:change", {
           id: payload.submission_id,
           target: target,
           elem: updated_submission
        })
      else
        $(document).trigger("submissions:new", {
          id: payload.submission_id,
          elem: updated_submission
        })
    , false)

    $('.submissions[data-live-update] > .submission') \
      .on('submissions:change', submission_onchange)

jQuery ->
  prepare()
  $(document).on("page:change", prepare)
  $(document).on("submissions:new", (e, d) ->
    console.log(d)
    d.elem.hide()
    $('.submissions[data-live-update]').prepend(d.elem)
    d.elem.slideDown()
    d.elem.on('submissions:change', submission_onchange)
  )

