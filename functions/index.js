const functions = require('firebase-functions');
const {Storage} = require('@google-cloud/storage');
const gcs = new Storage({});
const os = require('os');
const path = require('path');
const spawn = require('child-process-promise').spawn;
const runtimeOpts ={
    timeoutSeconds: 300,
    memory: '1GB'
}

exports.onImageUpload = functions
                            .runWith(runtimeOpts)
                            .storage
                            .object()
                            .onFinalize(event => {
    const bucket = event.bucket;
    const contentType = event.contentType;
    const filePath = event.name;
    const fileSize = event.size;
    console.log('Resizing img...');

    if(fileSize < 187500) {
        console.log('Already Small');
        return 0;
    }

    const destBucket = gcs.bucket(bucket);
    const tempFilePath = path.join(os.tmpdir(), path.basename(filePath));
    const metadata = {contentType: contentType};
    return destBucket.file(filePath).download({
        destination: tempFilePath
    }).then(() => {
        return spawn('convert', [tempFilePath, '-resize', '500x500', tempFilePath]);
    }).then(() => {
         return destBucket.upload(tempFilePath, {
                        destination: path.basename(filePath),
                        metadata: metadata
                    });
    });
});


