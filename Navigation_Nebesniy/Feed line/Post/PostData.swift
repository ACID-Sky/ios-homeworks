//
//  PostData.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 16.06.2022.
//

import UIKit
import StorageService

public let posts: [Post] = [
    Post(author: "Mark",
         description: "Siamang apes are the smartest, loudest, funniest, and personal animals in the jungle. \n When a siamang ape calls air comes and fills its neck making the neck expand like a bubble. You can see this in the picture above. The call is a high pitched sound in short bursts. It is so loud it can be heard over a kilometre away. Each siamang ape has a different call. They do the call to communicate and send information.",
         image: "animal",
         likes: 10,
         views: 1000,
         id: UUID().uuidString),
    Post(author: "Wikipedia",
         description: "The first recorded European sighting of the Australian mainland, and the first recorded European landfall on the Australian continent, are attributed to the Dutch.[61] The first ship and crew to chart the Australian coast and meet with Aboriginal people was the Duyfken captained by Dutch navigator, Willem Janszoon.[62] He sighted the coast of Cape York Peninsula in early 1606, and made landfall on 26 February 1606 at the Pennefather River near the modern town of Weipa on Cape York.[63] Later that year, Spanish explorer Luís Vaz de Torres sailed through and navigated the Torres Strait Islands.[64] The Dutch charted the whole of the western and northern coastlines and named the island continent  during the 17th century, and although no attempt at settlement was made,[63] a number of shipwrecks left men either stranded or, as in the case of the Batavia in 1629, marooned for mutiny and murder, thus becoming the first Europeans to permanently inhabit the continent.[65] In 1770, Captain James Cook sailed along and mapped the east coast, which he named  and claimed for Great Britain.[66]",
         image: "Aust",
         likes: 12,
         views: 2000,
         id: UUID().uuidString),
    Post(author: "Wikipedia",
         description: "A dolphin is an aquatic mammal within the infraorder Cetacea. Dolphin species belong to the families Delphinidae (the oceanic dolphins), Platanistidae (the Indian river dolphins), Iniidae (the New World river dolphins), Pontoporiidae (the brackish dolphins), and the extinct Lipotidae (baiji or Chinese river dolphin). There are 40 extant species named as dolphins.",
         image: "Delph",
         likes: 15,
         views: 1500,
         id: UUID().uuidString),
    Post(author: "Wikipedia",
         description: "The Sun is the star at the center of the Solar System. It is a nearly perfect ball of hot plasma,[18][19] heated to incandescence by nuclear fusion reactions in its core, radiating the energy mainly as visible light, ultraviolet, and infrared radiation. It is the most important source of energy for life on Earth.",
         image: "Sun",
         likes: 3,
         views: 1100,
         id: UUID().uuidString),
    ]

