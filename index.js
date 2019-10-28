var SlackBot = require("slackbots");
const { exec } = require("child_process");

var config = require("./config/config.json");
config.slack.token = config.slack.token || process.env.SLACK_CHATOPS_TOKEN;
var bot = new SlackBot(config.slack);

function requireUncached(module) {
  delete require.cache[require.resolve(module)];
  return require(module);
}

bot.on("message", msg => {
  if (msg.username === config.slack.name) return;
  if (msg.type !== "message") return;
  if (msg.error) return;
  if (!msg.text) return;
  const parts = msg.text.toLowerCase().split(" ");
  config = requireUncached("./config/config.json");
  respond(config.actions, parts);
});

const runScript = script =>
  exec(script, (err, stdout) => {
    if (err) return say(":rotating_light:" + err);
    say(":cat:" + stdout);
  });

const say = msg => {
  bot.postMessageToGroup(config.slack.channel, msg);
};

function respond(actions, query) {
  const [command, ...args] = query;
  if (!command) return;
  const action = actions[command];
  if (!action) return;
  if (args.length > 0) return respond(action.verbs, args);
  if (action.message) say(action.message);
  if (action.script) runScript(action.script);

  if (action.verbs)
    say(":book: Can " + command + ": " + Object.keys(action.verbs).join(", "));
}
