require 'kadath'

Kadath.render("osc~ 440" >~ "dac~")
Kadath.start_audio
sleep(1)
Kadath.stop_audio