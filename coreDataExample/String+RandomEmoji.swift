//
//  String+RandomEmoji.swift
//  coreDataExample
//
//  Created by Игорь Чернышов on 08.10.2023.
//

extension String {
	static let emojis = ["😏","⭐️","🤷🏻‍♂️","🌚","😒","🍌","😅","👠","🤣","💪🏻","❤️","🫶🏻","🫤","🤘🏻","🫂","🤔","🐿️"]
	static var randomEmoji: String { String.emojis.randomElement() ?? "?" }
}
