
function convertVideoToWav(pathToFile) {
	var ffmpeg = require('fluent-ffmpeg');
	let track = pathToFile;

	ffmpeg(track)
	.withAudioChannels(1)
	.withAudioBitrate(16000)
	.toFormat('wav')
	.on('error', (err) => {
    	console.log('An error occurred: ' + err.message);
	})
	.on('progress', (progress) => {
    	console.log('Processing: ' + progress.targetSize + ' KB converted');
	})
	.on('end', () => {
    	console.log('Processing finished !');
	})
	.save('audio.wav');
}
