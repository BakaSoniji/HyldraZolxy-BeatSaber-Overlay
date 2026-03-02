import { Globals } from "./global.js";
import { Tools } from "./tools.js";

export class ScoreSaber {

    /////////////////////
    // @CLASS VARIABLE //
    /////////////////////
    private _tools: Tools;

    constructor() {
        this._tools = new Tools();
    }

    /////////////////////
    // PUBLIC FUNCTION //
    /////////////////////
    public async getPlayerInfo(playerId: string): Promise<Globals.I_scoreSaberPlayerJSON> {
        return await this._tools.getMethod(Globals.SCORESABER_API_PROXY_URL + "/player/" + playerId + "/basic");
    }
}