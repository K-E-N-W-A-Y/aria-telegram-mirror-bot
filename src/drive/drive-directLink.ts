import constants = require('../.constants');
import driveAuth = require('./drive-auth');
import { google } from 'googleapis';

export async function getGDindexLink(fileId: string, isUrl?: boolean) {
    if (isUrl) {
        let url = fileId.match(/[-\w]{25,}/);
        fileId = Array.isArray(url) && url.length > 0 ? url[0] : ''
    }
    return new Promise(async (resolve, reject) => {
        if (fileId) {
            driveAuth.call((authErr, auth) => {
                if (authErr) {
                    reject(authErr);
                }
                const drive = google.drive({ version: 'v3', auth });

                drive.files.get({ fileId: fileId, fields: 'id, name, parents, mimeType', supportsAllDrives: true },
                    async (err: Error, res: any) => {
                        if (err) {
                            reject(err.message);
                        } else {
                            if (res.data) {
                                const filePath = await getFilePathDrive(res.data.parents, drive);
                                let path = filePath.path + res.data.name;
                                let url = constants.INDEX_DOMAIN + encodeURIComponent(path);
                                if (res.data.mimeType === 'application/vnd.google-apps.folder') {
                                    url += '/'
                                }
                                url += '?rootId=' + filePath.rootId;
                                resolve(isUrl ? { url: url, name: res.data.name } : url);
                            } else {
                                reject('🔥 error: %o : File not found');
                            }
                        }
                    });
            });
        } else {
            reject('🔥 error: %o : File id not found');
        }
    });
}

async function getFilePathDrive(parents: any, drive: any): Promise<{ path: string, rootId: string }> {
    let parent = parents;
    let tree = [];
    let path: string = '';
    if (parent) {
        do {
            const f = await drive.files.get({ fileId: parent[0], fields: 'id, name, parents', supportsAllDrives: true });
            parent = f.data.parents;
            if (!parent) break;
            tree.push({ 'id': parent[0], 'name': f.data.name })
        } while (true);
    }
    tree.reverse();
    for (const folder of tree) {
        if (folder.name !== 'Stuffs') {
            path += folder.name + '/';
        }
    }
    let rootId = tree.length > 0 ? tree[0].id : parents[0];
    return { path, rootId };
}
