extends Node2D

var set_name = "cmm"
var common = [6, 7, 9, 12, 17, 19, 25, 26, 36, 43, 44, 48, 56, 58, 61, 62, 63, 64, 66, 67, 69, 81, 83, 86, 87, 90, 93, 95, 96, 98, 99, 102, 107, 114, 115, 116, 119, 131, 133, 135, 134, 141, 142, 143, 149, 152, 153, 154, 159, 170, 171, 174, 175, 178, 182, 185, 188, 
190, 192, 194, 199, 203, 208, 210, 211, 212, 217, 219, 220, 223, 226, 229, 234, 239, 242, 248, 249, 256, 257, 262, 264, 269, 277, 278, 279, 281, 282, 284, 285, 288, 297, 300, 301, 302, 312, 314, 318, 321, 322, 323, 328, 370, 372, 374, 377, 378, 380, 383, 385, 389,
 390, 397, 400, 402, 403, 404, 412, 416, 418, 417, 419, 420, 422, 423, 428, 429, 430, 432, 431, 433]

var uncommon = [4, 8, 11, 15, 18, 20, 21, 22, 23, 30, 31, 33, 34, 35, 38, 40, 41, 47, 49, 50, 52, 65, 72, 75, 78, 82, 88, 91, 97, 100, 101, 104, 106, 109, 111, 112, 113, 117, 126, 127, 129, 132, 136, 138, 140, 145, 156, 157, 158, 160, 162, 163, 164, 166, 168, 172,
 179, 183, 186, 189, 195, 198, 201, 202, 204, 209, 221, 224, 225, 230, 233, 237, 240, 243, 247, 250, 251, 254, 255, 258, 260, 261, 266, 267, 268, 270, 271, 273, 275, 286, 291, 293, 296, 298, 304, 305, 306, 307, 311, 313, 317, 315, 326, 330, 332, 333, 335, 336, 339,
 341, 345, 351, 356, 357, 358, 360, 367, 368, 369, 373, 382, 384, 386, 391, 398, 399, 406, 410, 409, 411, 414, 415, 421, 426, 425]

var rare = [10, 13, 16, 24, 27, 28, 32, 42, 45, 46, 51, 53, 54, 55, 59, 60, 68, 70, 71, 73, 74, 76, 80, 84, 85, 89, 92, 94, 103, 105, 108, 110, 118, 121, 122, 124, 125, 128, 139, 144, 146, 147, 148, 151, 155, 161, 167, 169, 176, 177, 180, 184, 187, 191, 196, 197,
 200, 205, 206, 213, 214, 215, 216, 218, 222, 227, 228, 232, 231, 235, 238, 241, 245, 253, 259, 263, 265, 272, 274, 276, 287, 290, 292, 295, 299, 303, 308, 309, 316, 319, 324, 325, 327, 329, 331, 334, 337, 338, 340, 342, 343, 344, 346, 347, 348, 349, 350, 352, 354,
 355, 359, 362, 363, 364, 365, 366, 371, 375, 376, 379, 388, 387, 392, 394, 395, 401, 405, 407, 408, 413, 424, 427, 434, 436, 435]

var mythic = [2, 3, 5, 14, 29, 37, 39, 57, 77, 79, 120, 123, 130, 137, 150, 165, 173, 181, 193, 207, 236, 244, 246, 252, 280, 283, 289, 294, 310, 320, 353, 361, 381, 393, 396]

var etchedRare = [455, 456, 458, 459, 460, 461, 463, 466, 468, 467, 469, 470, 471, 472, 474, 475, 476, 477, 478, 480, 479, 481, 484, 485, 486, 488, 487, 489, 490, 491, 492, 493, 494, 496, 497, 499, 500, 501, 504, 506, 507, 505, 508, 510, 511, 512, 514, 515, 517, 518,
 519, 521, 522, 523, 525, 526, 527, 528, 529, 531, 532, 533, 534, 535, 536, 537, 538, 540, 539, 541, 543, 544, 546, 549, 550, 551, 552, 553, 554, 555, 558, 560, 561, 563, 564, 565, 566, 567, 569, 570, 572, 573, 574, 576, 575, 577, 578, 579, 580, 581, 582, 583, 584, 585,
 586, 587, 588, 589, 591, 592, 593, 596, 595, 597, 598, 599, 600, 601, 602, 603, 605, 606, 607, 609, 610, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621]

var etchedMythic = [452, 453, 454, 457, 462, 464, 465, 473, 482, 483, 495, 498, 502, 503, 509, 513, 516, 520, 524, 530, 542, 545, 547, 548, 556, 557, 559, 562, 568, 571, 590, 594, 604, 608, 611]


var boarderlesscommon = [622, 624, 630, 632, 637, 641, 642, 649, 648, 655, 659, 661]

var boarderlessuncommon = [623, 626, 628, 631, 634, 638, 644, 646, 653, 657, 658, 660, 663]

var boarderlessRare = [625, 627, 629, 633, 636, 640, 643, 645, 647, 650, 651, 652, 654, 662, 664, 665, 666, 667]

var boarderlessMythic = [635, 639, 656]

var profileRare = [672, 673, 677, 679, 682, 683, 684, 685, 688, 690, 691]

var profileMythic = [668, 669, 670, 674, 675, 678, 680, 681, 689]

var framebreakUncommon = [703]

var framebreakRare = [692, 694, 695, 698, 701]

var framebreakMythic = [693, 696, 697, 699, 700, 702]

var extenedRare = [744, 745, 746, 747, 749, 750, 751, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 778]

var extendedMythic = [748, 752, 773, 774, 775, 776, 777]


var texturedMythic = [1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066]


func _ready() -> void:
	$"..".ensure_directory_exists("user://Cards/cmm")
	for x in range(1057, 1067):
		#grabCardExtra(x, 4, 0, 0, false, true)
		await get_tree().create_timer(0.5).timeout
	#grabCardExtra(1, 0, 0, 0, true, false)
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			#print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	print(("common: "),Player.common)
	print(("uncommon: "),Player.uncommon)
	print(("rare: "),Player.rare)
	print(("mythic: "),Player.mythic)
	
	
func grabCard (list: Array, foilEnum: int, posX: float, posY: float, isLast: bool) -> void:
	var pos = Vector2(posX, posY)
	var num = list.pick_random();
	var CardGrabber = preload("res://Card_Grabber.gd")
	var grab = Card_Grabber.new(num, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast);
	print("started")
	add_child(grab)
	pass


func grabCardExtra (list: int, foilEnum: int, posX: float, posY: float, isLast: bool, isGrabbing) -> void:
	var pos = Vector2(posX, posY)
	
	var CardGrabber = preload("res://Card_Grabber.gd")
	var grab = Card_Grabber.new(list, set_name, foilEnum, "user://Cards/" + set_name, pos, isLast, isGrabbing);
	print("started")
	add_child(grab)
	pass

func createDraftPack () -> void:
	
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.showBar()
	
	print("Inventory ", Player.IDInventory)
	$"..".drawBackButton();

func createCollectorPack ():
	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.showBar()
	
	print("Inventory ", Player.IDInventory)
	$"..".drawBackButton();
	pass

func createSetPack ():

	
	await HttpData.Finished
	while HttpData.get_child_count() > 0:
			print("waiting", HttpData.get_child_count())
			await get_tree().process_frame
	
	var levelLabel = get_node("/root/Main/CanvasLayer/VScrollBar_PackOpening")
	levelLabel.startShowBar()
	$"..".drawBackButton();
	pass

func getRarityByWeight(arrays: Array, weights: Array):
	var random = RandomNumberGenerator.new()
	
	return arrays[random.rand_weighted(weights)]
