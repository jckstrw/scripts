# Description:
#   Bubbles drops knowledge
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot what would bubbles say  - Receive wisdom

quotes =
  bubbles_list: [
    "What a greasy horror show...",
    "Deeeecent!!",
    "Kitties aren't supposed to smell like cigarettes, they're supposed to smell like kitties!", 
    "No Mr. Lahey, PLEASE, we don't want to go to Fucktown!",
    "Jesus Murphy!",
    "Green Bastard, from parts unknown!",
    "You all right, Corey? I don't give a fuck, actually.",
    "Lahey, can you please get the flying fuck out of our way? We gotta go get Rush tickets!", 
    "Is it just me, or can someone here go fuck themselves?",
    "Ah, swish is this old dirty homemade liquor, and you can barely get 'er into ya'. But my fuck, does it ever get ya' some drunk!",
    "How many cheeseburgers are you gonna drive into that dirty old cheeseburger locker Randy?", 
    "He's just a big, stoned, horny kitty with the munchies!",
    "Well I guess that makes you long john dick weed.",
    "Mission control, this is Commander Bubbles.  I'm gettin an MPS warning light on the link monitor control sub system, I'm requesting relocation of main ohm fire through the CDS at level 6...please advise! Copy that?",
    "Can I come out now? I think I have a leech on my bird.",
    "Julian, we're both baked. That's why were probably not making any sense.",
    "COCK-SUCKER!",
    "Oh, nice job there, son of the mustard tiger!",
    "Ray...rippin' the plumbin' outta your walls for liquor money...IS fucked!",
    "It's Samsquamtch Ricky, and there's one right outside my fuckin' door right now, he's trying to get into my shed!",
    "Everybody calm down!! For fucks sakes! Is this all about cheeseburgers?!",
    "J-Roc, you better straighten Panama Jack the fuck out right now."
    "(singing) Fuckin' Randy's gut, it's full of dirty little cheeseburgers..." 

  ]

module.exports = (robot) ->
  robot.respond /what would bubbles say/i, (msg) ->
    type = quotes.bubbles_list
    msg.send msg.random type
