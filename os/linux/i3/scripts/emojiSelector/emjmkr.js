const { open, access, constants } = require('node:fs/promises');

(async () => {
	// console.log('init')
	// open('./all_emojis.txt').then( async f => {
	// 	const emjs =  []
	// 	for await (const line of f.readLines()){
	// 		const elmts = line.split("	")
	// 		const tmpObj = {}
	// 		tmpObj.emoji = elmts[0]
	// 		tmpObj.category = elmts[1]
	// 		tmpObj.description = elmts.slice(2, elmts.length-2).join()
	// 		tmpObj.tags = (elmts[elmts.length-1]).split("|")
	// 		emjs.push(tmpObj)
	// 	}
	// 	console.log(emjs.length)
	// 	f.close()
	// })
	// console.log('end')

	const file = await open('./all_emojis.txt');
	const emjs =  []
	for await (const line of file.readLines()) {
		const elmts = line.split("	")
		const tmpObj = {
			emoji: elmts[0],
			description: elmts.slice(2, elmts.length-2).join(),
			category: elmts[1],
			aliases: [],
			// tags: (elmts[elmts.length-1]).split("|"),
			tags: (elmts[elmts.length-1]).split("|").map(el=>el.trim()),
			unicode_version: 6.1,
			ios_version: 6.0
		}
		// tmpObj.emoji = 
		// tmpObj.category = elmts[1]
		// tmpObj.description = elmts.slice(2, elmts.length-2).join()
		// tmpObj.tags = (elmts[elmts.length-1]).split("|")
		emjs.push(tmpObj)
	}
	// save in the file
	try {
		open('./emojis_all.json','w').then(f => {
			f.write(JSON.stringify(emjs))
		})
	} catch {
		console.log('errro to save file')
	}
})();
