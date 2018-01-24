/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/dist";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _amber = __webpack_require__(1);

var _amber2 = _interopRequireDefault(_amber);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var EVENTS = {
  join: 'join',
  leave: 'leave',
  message: 'message'
};
var STALE_CONNECTION_THRESHOLD_SECONDS = 100;
var SOCKET_POLLING_RATE = 10000;

/**
 * Returns a numeric value for the current time
 */
var now = function now() {
  return new Date().getTime();
};

/**
 * Returns the difference between the current time and passed `time` in seconds
 * @param {Number|Date} time - A numeric time or date object
 */
var secondsSince = function secondsSince(time) {
  return (now() - time) / 1000;
};

/**
 * Class for channel related functions (joining, leaving, subscribing and sending messages)
 */

var Channel = exports.Channel = function () {
  /**
   * @param {String} topic - topic to subscribe to
   * @param {Socket} socket - A Socket instance
   */
  function Channel(topic, socket) {
    _classCallCheck(this, Channel);

    this.topic = topic;
    this.socket = socket;
    this.onMessageHandlers = [];
  }

  /**
   * Join a channel, subscribe to all channels messages
   */


  _createClass(Channel, [{
    key: 'join',
    value: function join() {
      this.socket.ws.send(JSON.stringify({ event: EVENTS.join, topic: this.topic }));
    }

    /**
     * Leave a channel, stop subscribing to channel messages
     */

  }, {
    key: 'leave',
    value: function leave() {
      this.socket.ws.send(JSON.stringify({ event: EVENTS.leave, topic: this.topic }));
    }

    /**
     * Calls all message handlers with a matching subject
     */

  }, {
    key: 'handleMessage',
    value: function handleMessage(msg) {
      this.onMessageHandlers.forEach(function (handler) {
        if (handler.subject === msg.subject) handler.callback(msg.payload);
      });
    }

    /**
     * Subscribe to a channel subject
     * @param {String} subject - subject to listen for: `msg:new`
     * @param {function} callback - callback function when a new message arrives
     */

  }, {
    key: 'on',
    value: function on(subject, callback) {
      this.onMessageHandlers.push({ subject: subject, callback: callback });
    }

    /**
     * Send a new message to the channel
     * @param {String} subject - subject to send message to: `msg:new`
     * @param {Object} payload - payload object: `{message: 'hello'}`
     */

  }, {
    key: 'push',
    value: function push(subject, payload) {
      this.socket.ws.send(JSON.stringify({ event: EVENTS.message, topic: this.topic, subject: subject, payload: payload }));
    }
  }]);

  return Channel;
}();

/**
 * Class for maintaining connection with server and maintaining channels list
 */


var Socket = exports.Socket = function () {
  /**
   * @param {String} endpoint - Websocket endpont used in routes.cr file
   */
  function Socket(endpoint) {
    _classCallCheck(this, Socket);

    this.endpoint = endpoint;
    this.ws = null;
    this.channels = [];
    this.lastPing = now();
    this.reconnectTries = 0;
    this.attemptReconnect = true;
  }

  /**
   * Returns whether or not the last received ping has been past the threshold
   */


  _createClass(Socket, [{
    key: '_connectionIsStale',
    value: function _connectionIsStale() {
      return secondsSince(this.lastPing) > STALE_CONNECTION_THRESHOLD_SECONDS;
    }

    /**
     * Tries to reconnect to the websocket server using a recursive timeout
     */

  }, {
    key: '_reconnect',
    value: function _reconnect() {
      var _this = this;

      clearTimeout(this.reconnectTimeout);
      this.reconnectTimeout = setTimeout(function () {
        _this.reconnectTries++;
        _this.connect(_this.params);
        _this._reconnect();
      }, this._reconnectInterval());
    }

    /**
     * Returns an incrementing timeout interval based around the number of reconnection retries
     */

  }, {
    key: '_reconnectInterval',
    value: function _reconnectInterval() {
      return [1000, 2000, 5000, 10000][this.reconnectTries] || 10000;
    }

    /**
     * Sets a recursive timeout to check if the connection is stale
     */

  }, {
    key: '_poll',
    value: function _poll() {
      var _this2 = this;

      this.pollingTimeout = setTimeout(function () {
        if (_this2._connectionIsStale()) {
          _this2._reconnect();
        } else {
          _this2._poll();
        }
      }, SOCKET_POLLING_RATE);
    }

    /**
     * Clear polling timeout and start polling
     */

  }, {
    key: '_startPolling',
    value: function _startPolling() {
      clearTimeout(this.pollingTimeout);
      this._poll();
    }

    /**
     * Sets `lastPing` to the curent time
     */

  }, {
    key: '_handlePing',
    value: function _handlePing() {
      this.lastPing = now();
    }

    /**
     * Clears reconnect timeout, resets variables an starts polling
     */

  }, {
    key: '_reset',
    value: function _reset() {
      clearTimeout(this.reconnectTimeout);
      this.reconnectTries = 0;
      this.attemptReconnect = true;
      this._startPolling();
    }

    /**
     * Connect the socket to the server, and binds to native ws functions
     * @param {Object} params - Optional parameters
     * @param {String} params.location - Hostname to connect to, defaults to `window.location.hostname`
     * @param {String} parmas.port - Port to connect to, defaults to `window.location.port`
     * @param {String} params.protocol - Protocol to use, either 'wss' or 'ws'
     */

  }, {
    key: 'connect',
    value: function connect(params) {
      var _this3 = this;

      this.params = params;

      var opts = {
        location: window.location.hostname,
        port: window.location.port,
        protocol: window.location.protocol === 'https:' ? 'wss:' : 'ws:'
      };

      if (params) Object.assign(opts, params);
      if (opts.port) opts.location += ':' + opts.port;

      return new Promise(function (resolve, reject) {
        _this3.ws = new WebSocket(opts.protocol + '//' + opts.location + _this3.endpoint);
        _this3.ws.onmessage = function (msg) {
          _this3.handleMessage(msg);
        };
        _this3.ws.onclose = function () {
          if (_this3.attemptReconnect) _this3._reconnect();
        };
        _this3.ws.onopen = function () {
          _this3._reset();
          resolve();
        };
      });
    }

    /**
     * Closes the socket connection permanently
     */

  }, {
    key: 'disconnect',
    value: function disconnect() {
      this.attemptReconnect = false;
      clearTimeout(this.pollingTimeout);
      clearTimeout(this.reconnectTimeout);
      this.ws.close();
    }

    /**
     * Adds a new channel to the socket channels list
     * @param {String} topic - Topic for the channel: `chat_room:123`
     */

  }, {
    key: 'channel',
    value: function channel(topic) {
      var channel = new Channel(topic, this);
      this.channels.push(channel);
      return channel;
    }

    /**
     * Message handler for messages received
     * @param {MessageEvent} msg - Message received from ws
     */

  }, {
    key: 'handleMessage',
    value: function handleMessage(msg) {
      if (msg.data === "ping") return this._handlePing();

      var parsed_msg = JSON.parse(msg.data);
      this.channels.forEach(function (channel) {
        if (channel.topic === parsed_msg.topic) channel.handleMessage(parsed_msg);
      });
    }
  }]);

  return Socket;
}();

module.exports = {
  Socket: Socket
};

/***/ })
/******/ ]);
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly8vd2VicGFjay9ib290c3RyYXAgMDlmMzYxMmMyOTdlODI0NDZkNDkiLCJ3ZWJwYWNrOi8vLy4vc3JjL2Fzc2V0cy9qYXZhc2NyaXB0cy9tYWluLmpzIiwid2VicGFjazovLy8uL2xpYi9hbWJlci9hc3NldHMvanMvYW1iZXIuanMiXSwibmFtZXMiOlsiRVZFTlRTIiwiam9pbiIsImxlYXZlIiwibWVzc2FnZSIsIlNUQUxFX0NPTk5FQ1RJT05fVEhSRVNIT0xEX1NFQ09ORFMiLCJTT0NLRVRfUE9MTElOR19SQVRFIiwibm93IiwiRGF0ZSIsImdldFRpbWUiLCJzZWNvbmRzU2luY2UiLCJ0aW1lIiwiQ2hhbm5lbCIsInRvcGljIiwic29ja2V0Iiwib25NZXNzYWdlSGFuZGxlcnMiLCJ3cyIsInNlbmQiLCJKU09OIiwic3RyaW5naWZ5IiwiZXZlbnQiLCJtc2ciLCJmb3JFYWNoIiwiaGFuZGxlciIsInN1YmplY3QiLCJjYWxsYmFjayIsInBheWxvYWQiLCJwdXNoIiwiU29ja2V0IiwiZW5kcG9pbnQiLCJjaGFubmVscyIsImxhc3RQaW5nIiwicmVjb25uZWN0VHJpZXMiLCJhdHRlbXB0UmVjb25uZWN0IiwiY2xlYXJUaW1lb3V0IiwicmVjb25uZWN0VGltZW91dCIsInNldFRpbWVvdXQiLCJjb25uZWN0IiwicGFyYW1zIiwiX3JlY29ubmVjdCIsIl9yZWNvbm5lY3RJbnRlcnZhbCIsInBvbGxpbmdUaW1lb3V0IiwiX2Nvbm5lY3Rpb25Jc1N0YWxlIiwiX3BvbGwiLCJfc3RhcnRQb2xsaW5nIiwib3B0cyIsImxvY2F0aW9uIiwid2luZG93IiwiaG9zdG5hbWUiLCJwb3J0IiwicHJvdG9jb2wiLCJPYmplY3QiLCJhc3NpZ24iLCJQcm9taXNlIiwicmVzb2x2ZSIsInJlamVjdCIsIldlYlNvY2tldCIsIm9ubWVzc2FnZSIsImhhbmRsZU1lc3NhZ2UiLCJvbmNsb3NlIiwib25vcGVuIiwiX3Jlc2V0IiwiY2xvc2UiLCJjaGFubmVsIiwiZGF0YSIs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Q0Q7O0FBRUQ7Ozs7Ozs7NEJBSVFqRCxLLEVBQU87QUFDYixVQUFJa0QsVUFBVSxJQUFJbkQsT0FBSixDQUFZQyxLQUFaLEVBQW1CLElBQW5CLENBQWQ7QUFDQSxXQUFLaUIsUUFBTCxDQUFjSCxJQUFkLENBQW1Cb0MsT0FBbkI7QUFDQSxhQUFPQSxPQUFQO0FBQ0Q7O0FBRUQ7Ozs7Ozs7a0NBSWMxQyxHLEVBQUs7QUFDakIsVUFBSUEsSUFBSTJDLElBQUosS0FBYSxNQUFqQixFQUF5QixPQUFPLEtBQUtDLFdBQUwsRUFBUDs7QUFFekIsVUFBSUMsYUFBYWhELEtBQUtpRCxLQUFMLENBQVc5QyxJQUFJMkMsSUFBZixDQUFqQjtBQUNBLFdBQUtsQyxRQUFMLENBQWNSLE9BQWQsQ0FBc0IsVUFBQ3lDLE9BQUQsRUFBYTtBQUNqQyxZQUFJQSxRQUFRbEQsS0FBUixLQUFrQnFELFdBQVdyRCxLQUFqQyxFQUF3Q2tELFFBQVFMLGFBQVIsQ0FBc0JRLFVBQXRCO0FBQ3pDLE9BRkQ7QUFHRDs7Ozs7O0FBR0hFLE9BQU9DLE9BQVAsR0FBaUI7QUFDZnpDLFVBQVFBO0FBRE8sQ0FBakIsQyIsImZpbGUiOiJtYWluLmJ1bmRsZS5qcyIsInNvdXJjZXNDb250ZW50IjpbIiBcdC8vIFRoZSBtb2R1bGUgY2FjaGVcbiBcdHZhciBpbnN0YWxsZWRNb2R1bGVzID0ge307XG5cbiBcdC8vIFRoZSByZXF1aXJlIGZ1bmN0aW9uXG4gXHRmdW5jdGlvbiBfX3dlYnBhY2tfcmVxdWlyZV9fKG1vZHVsZUlkKSB7XG5cbiBcdFx0Ly8gQ2hlY2sgaWYgbW9kdWxlIGlzIGluIGNhY2hlXG4gXHRcdGlmKGluc3RhbGxlZE1vZHVsZXNbbW9kdWxlSWRdKSB7XG4gXHRcdFx0cmV0dXJuIGluc3RhbGxlZE1vZHVsZXNbbW9kdWxlSWRdLmV4cG9ydHM7XG4gXHRcdH1cbiBcdFx0Ly8gQ3JlYXRlIGEgbmV3IG1vZHVsZSAoYW5kIHB1dCBpdCBpbnRvIHRoZSBjYWNoZSlcbiBcdFx0dmFyIG1vZHVsZSA9IGluc3RhbGxlZE1vZHVsZXNbbW9kdWxlSWRdID0ge1xuIFx0XHRcdGk6IG1vZHVsZUlkLFxuIFx0XHRcdGw6IGZhbHNlLFxuIFx0XHRcdGV4cG9ydHM6IHt9XG4gXHRcdH07XG5cbiBcdFx0Ly8gRXhlY3V0ZSB0aGUgbW9kdWxlIGZ1bmN0aW9uXG4gXHRcdG1vZHVsZXNbbW9kdWxlSWRdLmNhbGwobW9kdWxlLmV4cG9ydHMsIG1vZHVsZSwgbW9kdWxlLmV4cG9ydHMsIF9fd2VicGFja19yZXF1aXJlX18pO1xuXG4gXHRcdC8vIEZsYWcgdGhlIG1vZHVsZSBhcyBsb2FkZWRcbiBcdFx0bW9kdWxlLmwgPSB0cnVlO1xuXG4gXHRcdC8vIFJldHVybiB0aGUgZXhwb3J0cyBvZiB0aGUgbW9kdWxlXG4gXHRcdHJldHVybiBtb2R1bGUuZXhwb3J0cztcbiBcdH1cblxuXG4gXHQvLyBleHBvc2UgdGhlIG1vZHVsZXMgb2JqZWN0IChfX3dlYnBhY2tfbW9kdWxlc19fKVxuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5tID0gbW9kdWxlcztcblxuIFx0Ly8gZXhwb3NlIHRoZSBtb2R1bGUgY2FjaGVcbiBcdF9fd2VicGFja19yZXF1aXJlX18uYyA9IGluc3RhbGxlZE1vZHVsZXM7XG5cbiBcdC8vIGRlZmluZSBnZXR0ZXIgZnVuY3Rpb24gZm9yIGhhcm1vbnkgZXhwb3J0c1xuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5kID0gZnVuY3Rpb24oZXhwb3J0cywgbmFtZSwgZ2V0dGVyKSB7XG4gXHRcdGlmKCFfX3dlYnBhY2tfcmVxdWlyZV9fLm8oZXhwb3J0cywgbmFtZSkpIHtcbiBcdFx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgbmFtZSwge1xuIFx0XHRcdFx0Y29uZmlndXJhYmxlOiBmYWxzZSxcbiBcdFx0XHRcdGVudW1lcmFibGU6IHRydWUsXG4gXHRcdFx0XHRnZXQ6IGdldHRlclxuIFx0XHRcdH0pO1xuIFx0XHR9XG4gXHR9O1xuXG4gXHQvLyBnZXREZWZhdWx0RXhwb3J0IGZ1bmN0aW9uIGZvciBjb21wYXRpYmlsaXR5IHdpdGggbm9uLWhhcm1vbnkgbW9kdWxlc1xuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5uID0gZnVuY3Rpb24obW9kdWxlKSB7XG4gXHRcdHZhciBnZXR0ZXIgPSBtb2R1bGUgJiYgbW9kdWxlLl9fZXNNb2R1bGUgP1xuIFx0XHRcdGZ1bmN0aW9uIGdldERlZmF1bHQoKSB7IHJldHVybiBtb2R1bGVbJ2RlZmF1bHQnXTsgfSA6XG4gXHRcdFx0ZnVuY3Rpb24gZ2V0TW9kdWxlRXhwb3J0cygpIHsgcmV0dXJuIG1vZHVsZTsgfTtcbiBcdFx0X193ZWJwYWNrX3JlcXVpcmVfXy5kKGdldHRlciwgJ2EnLCBnZXR0ZXIpO1xuIFx0XHRyZXR1cm4gZ2V0dGVyO1xuIFx0fTtcblxuIFx0Ly8gT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eS5jYWxsXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLm8gPSBmdW5jdGlvbihvYmplY3QsIHByb3BlcnR5KSB7IHJldHVybiBPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5LmNhbGwob2JqZWN0LCBwcm9wZXJ0eSk7IH07XG5cbiBcdC8vIF9fd2VicGFja19wdWJsaWNfcGF0aF9fXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLnAgPSBcIi9kaXN0XCI7XG5cbiBcdC8vIExvYWQgZW50cnkgbW9kdWxlIGFuZCByZXR1cm4gZXhwb3J0c1xuIFx0cmV0dXJuIF9fd2VicGFja19yZXF1aXJlX18oX193ZWJwYWNrX3JlcXVpcmVfXy5zID0gMCk7XG5cblxuXG4vLyBXRUJQQUNLIEZPT1RFUiAvL1xuLy8gd2VicGFjay9ib290c3RyYXAgMDlmMzYxMmMyOTdlODI0NDZkNDkiLCJpbXBvcnQgQW1iZXIgZnJvbSAnYW1iZXInXG5cblxuXG4vLyBXRUJQQUNLIEZPT1RFUiAvL1xuLy8gLi9zcmMvYXNzZXRzL2phdmFzY3JpcHRzL21haW4uanMiLCJjb25zdCBFVkVOVFMgPSB7XG4gIGpvaW46ICdqb2luJyxcbiAgbGVhdmU6ICdsZWF2ZScsXG4gIG1lc3NhZ2U6ICdtZXNzYWdlJ1xufVxuY29uc3QgU1RBTEVfQ09OTkVDVElPTl9USFJFU0hPTERfU0VDT05EUyA9IDEwMFxuY29uc3QgU09DS0VUX1BPTExJTkdfUkFURSA9IDEwMDAwXG5cbi8qKlxuICogUmV0dXJucyBhIG51bWVyaWMgdmFsdWUgZm9yIHRoZSBjdXJyZW50IHRpbWVcbiAqL1xubGV0IG5vdyA9ICgpID0+IHtcbiAgcmV0dXJuIG5ldyBEYXRlKCkuZ2V0VGltZSgpXG59XG5cbi8qKlxuICogUmV0dXJucyB0aGUgZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSBjdXJyZW50IHRpbWUgYW5kIHBhc3NlZCBgdGltZWAgaW4gc2Vjb25kc1xuICogQHBhcmFtIHtOdW1iZXJ8RGF0ZX0gdGltZSAtIEEgbnVtZXJpYyB0aW1lIG9yIGRhdGUgb2JqZWN0XG4gKi9cbmxldCBzZWNvbmRzU2luY2UgPSAodGltZSkgPT4ge1xuICByZXR1cm4gKG5vdygpIC0gdGltZSkgLyAxMDAwXG59XG5cbi8qKlxuICogQ2xhc3MgZm9yIGNoYW5uZWwgcmVsYXRlZCBmdW5jdGlvbnMgKGpvaW5pbmcsIGxlYXZpbmcsIHN1YnNjcmliaW5nIGFuZCBzZW5kaW5nIG1lc3NhZ2VzKVxuICovXG5leHBvcnQgY2xhc3MgQ2hhbm5lbCB7XG4gIC8qKlxuICAgKiBAcGFyYW0ge1N0cmluZ30gdG9waWMgLSB0b3BpYyB0byBzdWJzY3JpYmUgdG9cbiAgICogQHBhcmFtIHtTb2NrZXR9IHNvY2tldCAtIEEgU29ja2V0IGluc3RhbmNlXG4gICAqL1xuICBjb25zdHJ1Y3Rvcih0b3BpYywgc29ja2V0KSB7XG4gICAgdGhpcy50b3BpYyA9IHRvcGljXG4gICAgdGhpcy5zb2NrZXQgPSBzb2NrZXRcbiAgICB0aGlzLm9uTWVzc2FnZUhhbmRsZXJzID0gW11cbiAgfVxuXG4gIC8qKlxuICAgKiBKb2luIGEgY2hhbm5lbCwgc3Vic2NyaWJlIHRvIGFsbCBjaGFubmVscyBtZXNzYWdlc1xuICAgKi9cbiAgam9pbigpIHtcbiAgICB0aGlzLnNvY2tldC53cy5zZW5kKEpTT04uc3RyaW5naWZ5KHsgZXZlbnQ6IEVWRU5UUy5qb2luLCB0b3BpYzogdGhpcy50b3BpYyB9KSlcbiAgfVxuXG4gIC8qKlxuICAgKiBMZWF2ZSBhIGNoYW5uZWwsIHN0b3Agc3Vic2NyaWJpbmcgdG8gY2hhbm5lbCBtZXNzYWdlc1xuICAgKi9cbiAgbGVhdmUoKSB7XG4gICAgdGhpcy5zb2NrZXQud3Muc2VuZChKU09OLnN0cmluZ2lmeSh7IGV2ZW50OiBFVkVOVFMubGVhdmUsIHRvcGljOiB0aGlzLnRvcGljIH0pKVxuICB9XG5cbiAgLyoqXG4gICAqIENhbGxzIGFsbCBtZXNzYWdlIGhhbmRsZXJzIHdpdGggYSBtYXRjaGluZyBzdWJqZWN0XG4gICAqL1xuICBoYW5kbGVNZXNzYWdlKG1zZykge1xuICAgIHRoaXMub25NZXNzYWdlSGFuZGxlcnMuZm9yRWFjaCgoaGFuZGxlcikgPT4ge1xuICAgICAgaWYgKGhhbmRsZXIuc3ViamVjdCA9PT0gbXNnLnN1YmplY3QpIGhhbmRsZXIuY2FsbGJhY2sobXNnLnBheWxvYWQpXG4gICAgfSlcbiAgfVxuXG4gIC8qKlxuICAgKiBTdWJzY3JpYmUgdG8gYSBjaGFubmVsIHN1YmplY3RcbiAgICogQHBhcmFtIHtTdHJpbmd9IHN1YmplY3QgLSBzdWJqZWN0IHRvIGxpc3RlbiBmb3I6IGBtc2c6bmV3YFxuICAgKiBAcGFyYW0ge2Z1bmN0aW9ufSBjYWxsYmFjayAtIGNhbGxiYWNrIGZ1bmN0aW9uIHdoZW4gYSBuZXcgbWVzc2FnZSBhcnJpdmVzXG4gICAqL1xuICBvbihzdWJqZWN0LCBjYWxsYmFjaykge1xuICAgIHRoaXMub25NZXNzYWdlSGFuZGxlcnMucHVzaCh7IHN1YmplY3Q6IHN1YmplY3QsIGNhbGxiYWNrOiBjYWxsYmFjayB9KVxuICB9XG5cbiAgLyoqXG4gICAqIFNlbmQgYSBuZXcgbWVzc2FnZSB0byB0aGUgY2hhbm5lbFxuICAgKiBAcGFyYW0ge1N0cmluZ30gc3ViamVjdCAtIHN1YmplY3QgdG8gc2VuZCBtZXNzYWdlIHRvOiBgbXNnOm5ld2BcbiAgICogQHBhcmFtIHtPYmplY3R9IHBheWxvYWQgLSBwYXlsb2FkIG9iamVjdDogYHttZXNzYWdlOiAnaGVsbG8nfWBcbiAgICovXG4gIHB1c2goc3ViamVjdCwgcGF5bG9hZCkge1xuICAgIHRoaXMuc29ja2V0LndzLnNlbmQoSlNPTi5zdHJpbmdpZnkoeyBldmVudDogRVZFTlRTLm1lc3NhZ2UsIHRvcGljOiB0aGlzLnRvcGljLCBzdWJqZWN0OiBzdWJqZWN0LCBwYXlsb2FkOiBwYXlsb2FkIH0pKVxuICB9XG59XG5cbi8qKlxuICogQ2xhc3MgZm9yIG1haW50YWluaW5nIGNvbm5lY3Rpb24gd2l0aCBzZXJ2ZXIgYW5kIG1haW50YWluaW5nIGNoYW5uZWxzIGxpc3RcbiAqL1xuZXhwb3J0IGNsYXNzIFNvY2tldCB7XG4gIC8qKlxuICAgKiBAcGFyYW0ge1N0cmluZ30gZW5kcG9pbnQgLSBXZWJzb2NrZXQgZW5kcG9udCB1c2VkIGluIHJvdXRlcy5jciBmaWxlXG4gICAqL1xuICBjb25zdHJ1Y3RvcihlbmRwb2ludCkge1xuICAgIHRoaXMuZW5kcG9pbnQgPSBlbmRwb2ludFxuICAgIHRoaXMud3MgPSBudWxsXG4gICAgdGhpcy5jaGFubmVscyA9IFtdXG4gICAgdGhpcy5sYXN0UGluZyA9IG5vdygpXG4gICAgdGhpcy5yZWNvbm5lY3RUcmllcyA9IDBcbiAgICB0aGlzLmF0dGVtcHRSZWNvbm5lY3QgPSB0cnVlXG4gIH1cblxuICAvKipcbiAgICogUmV0dXJucyB3aGV0aGVyIG9yIG5vdCB0aGUgbGFzdCByZWNlaXZlZCBwaW5nIGhhcyBiZWVuIHBhc3QgdGhlIHRocmVzaG9sZFxuICAgKi9cbiAgX2Nvbm5lY3Rpb25Jc1N0YWxlKCkge1xuICAgIHJldHVybiBzZWNvbmRzU2luY2UodGhpcy5sYXN0UGluZykgPiBTVEFMRV9DT05ORUNUSU9OX1RIUkVTSE9MRF9TRUNPTkRTXG4gIH1cblxuICAvKipcbiAgICogVHJpZXMgdG8gcmVjb25uZWN0IHRvIHRoZSB3ZWJzb2NrZXQgc2VydmVyIHVzaW5nIGEgcmVjdXJzaXZlIHRpbWVvdXRcbiAgICovXG4gIF9yZWNvbm5lY3QoKSB7XG4gICAgY2xlYXJUaW1lb3V0KHRoaXMucmVjb25uZWN0VGltZW91dClcbiAgICB0aGlzLnJlY29ubmVjdFRpbWVvdXQgPSBzZXRUaW1lb3V0KCgpID0+IHtcbiAgICAgIHRoaXMucmVjb25uZWN0VHJpZXMrK1xuICAgICAgdGhpcy5jb25uZWN0KHRoaXMucGFyYW1zKVxuICAgICAgdGhpcy5fcmVjb25uZWN0KClcbiAgICB9LCB0aGlzLl9yZWNvbm5lY3RJbnRlcnZhbCgpKVxuICB9XG5cbiAgLyoqXG4gICAqIFJldHVybnMgYW4gaW5jcmVtZW50aW5nIHRpbWVvdXQgaW50ZXJ2YWwgYmFzZWQgYXJvdW5kIHRoZSBudW1iZXIgb2YgcmVjb25uZWN0aW9uIHJldHJpZXNcbiAgICovXG4gIF9yZWNvbm5lY3RJbnRlcnZhbCgpIHtcbiAgICByZXR1cm4gWzEwMDAsIDIwMDAsIDUwMDAsIDEwMDAwXVt0aGlzLnJlY29ubmVjdFRyaWVzXSB8fCAxMDAwMFxuICB9XG5cbiAgLyoqXG4gICAqIFNldHMgYSByZWN1cnNpdmUgdGltZW91dCB0byBjaGVjayBpZiB0aGUgY29ubmVjdGlvbiBpcyBzdGFsZVxuICAgKi9cbiAgX3BvbGwoKSB7XG4gICAgdGhpcy5wb2xsaW5nVGltZW91dCA9IHNldFRpbWVvdXQoKCkgPT4ge1xuICAgICAgaWYgKHRoaXMuX2Nvbm5lY3Rpb25Jc1N0YWxlKCkpIHtcbiAgICAgICAgdGhpcy5fcmVjb25uZWN0KClcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIHRoaXMuX3BvbGwoKVxuICAgICAgfVxuICAgIH0sIFNPQ0tFVF9QT0xMSU5HX1JBVEUpXG4gIH1cblxuICAvKipcbiAgICogQ2xlYXIgcG9sbGluZyB0aW1lb3V0IGFuZCBzdGFydCBwb2xsaW5nXG4gICAqL1xuICBfc3RhcnRQb2xsaW5nKCkge1xuICAgIGNsZWFyVGltZW91dCh0aGlzLnBvbGxpbmdUaW1lb3V0KVxuICAgIHRoaXMuX3BvbGwoKVxuICB9XG5cbiAgLyoqXG4gICAqIFNldHMgYGxhc3RQaW5nYCB0byB0aGUgY3VyZW50IHRpbWVcbiAgICovXG4gIF9oYW5kbGVQaW5nKCkge1xuICAgIHRoaXMubGFzdFBpbmcgPSBub3coKVxuICB9XG5cbiAgLyoqXG4gICAqIENsZWFycyByZWNvbm5lY3QgdGltZW91dCwgcmVzZXRzIHZhcmlhYmxlcyBhbiBzdGFydHMgcG9sbGluZ1xuICAgKi9cbiAgX3Jlc2V0KCkge1xuICAgIGNsZWFyVGltZW91dCh0aGlzLnJlY29ubmVjdFRpbWVvdXQpXG4gICAgdGhpcy5yZWNvbm5lY3RUcmllcyA9IDBcbiAgICB0aGlzLmF0dGVtcHRSZWNvbm5lY3QgPSB0cnVlXG4gICAgdGhpcy5fc3RhcnRQb2xsaW5nKClcbiAgfVxuXG4gIC8qKlxuICAgKiBDb25uZWN0IHRoZSBzb2NrZXQgdG8gdGhlIHNlcnZlciwgYW5kIGJpbmRzIHRvIG5hdGl2ZSB3cyBmdW5jdGlvbnNcbiAgICogQHBhcmFtIHtPYmplY3R9IHBhcmFtcyAtIE9wdGlvbmFsIHBhcmFtZXRlcnNcbiAgICogQHBhcmFtIHtTdHJpbmd9IHBhcmFtcy5sb2NhdGlvbiAtIEhvc3RuYW1lIHRvIGNvbm5lY3QgdG8sIGRlZmF1bHRzIHRvIGB3aW5kb3cubG9jYXRpb24uaG9zdG5hbWVgXG4gICAqIEBwYXJhbSB7U3RyaW5nfSBwYXJtYXMucG9ydCAtIFBvcnQgdG8gY29ubmVjdCB0bywgZGVmYXVsdHMgdG8gYHdpbmRvdy5sb2NhdGlvbi5wb3J0YFxuICAgKiBAcGFyYW0ge1N0cmluZ30gcGFyYW1zLnByb3RvY29sIC0gUHJvdG9jb2wgdG8gdXNlLCBlaXRoZXIgJ3dzcycgb3IgJ3dzJ1xuICAgKi9cbiAgY29ubmVjdChwYXJhbXMpIHtcbiAgICB0aGlzLnBhcmFtcyA9IHBhcmFtc1xuXG4gICAgbGV0IG9wdHMgPSB7XG4gICAgICBsb2NhdGlvbjogd2luZG93LmxvY2F0aW9uLmhvc3RuYW1lLFxuICAgICAgcG9ydDogd2luZG93LmxvY2F0aW9uLnBvcnQsXG4gICAgICBwcm90b2NvbDogd2luZG93LmxvY2F0aW9uLnByb3RvY29sID09PSAnaHR0cHM6JyA/ICd3c3M6JyA6ICd3czonLFxuICAgIH1cblxuICAgIGlmIChwYXJhbXMpIE9iamVjdC5hc3NpZ24ob3B0cywgcGFyYW1zKVxuICAgIGlmIChvcHRzLnBvcnQpIG9wdHMubG9jYXRpb24gKz0gYDoke29wdHMucG9ydH1gXG5cbiAgICByZXR1cm4gbmV3IFByb21pc2UoKHJlc29sdmUsIHJlamVjdCkgPT4ge1xuICAgICAgdGhpcy53cyA9IG5ldyBXZWJTb2NrZXQoYCR7b3B0cy5wcm90b2NvbH0vLyR7b3B0cy5sb2NhdGlvbn0ke3RoaXMuZW5kcG9pbnR9YClcbiAgICAgIHRoaXMud3Mub25tZXNzYWdlID0gKG1zZykgPT4geyB0aGlzLmhhbmRsZU1lc3NhZ2UobXNnKSB9XG4gICAgICB0aGlzLndzLm9uY2xvc2UgPSAoKSA9PiB7XG4gICAgICAgIGlmICh0aGlzLmF0dGVtcHRSZWNvbm5lY3QpIHRoaXMuX3JlY29ubmVjdCgpXG4gICAgICB9XG4gICAgICB0aGlzLndzLm9ub3BlbiA9ICgpID0+IHtcbiAgICAgICAgdGhpcy5fcmVzZXQoKVxuICAgICAgICByZXNvbHZlKClcbiAgICAgIH1cbiAgICB9KVxuICB9XG5cbiAgLyoqXG4gICAqIENsb3NlcyB0aGUgc29ja2V0IGNvbm5lY3Rpb24gcGVybWFuZW50bHlcbiAgICovXG4gIGRpc2Nvbm5lY3QoKSB7XG4gICAgdGhpcy5hdHRlbXB0UmVjb25uZWN0ID0gZmFsc2VcbiAgICBjbGVhclRpbWVvdXQodGhpcy5wb2xsaW5nVGltZW91dClcbiAgICBjbGVhclRpbWVvdXQodGhpcy5yZWNvbm5lY3RUaW1lb3V0KVxuICAgIHRoaXMud3MuY2xvc2UoKVxuICB9XG5cbiAgLyoqXG4gICAqIEFkZHMgYSBuZXcgY2hhbm5lbCB0byB0aGUgc29ja2V0IGNoYW5uZWxzIGxpc3RcbiAgICogQHBhcmFtIHtTdHJpbmd9IHRvcGljIC0gVG9waWMgZm9yIHRoZSBjaGFubmVsOiBgY2hhdF9yb29tOjEyM2BcbiAgICovXG4gIGNoYW5uZWwodG9waWMpIHtcbiAgICBsZXQgY2hhbm5lbCA9IG5ldyBDaGFubmVsKHRvcGljLCB0aGlzKVxuICAgIHRoaXMuY2hhbm5lbHMucHVzaChjaGFubmVsKVxuICAgIHJldHVybiBjaGFubmVsXG4gIH1cblxuICAvKipcbiAgICogTWVzc2FnZSBoYW5kbGVyIGZvciBtZXNzYWdlcyByZWNlaXZlZFxuICAgKiBAcGFyYW0ge01lc3NhZ2VFdmVudH0gbXNnIC0gTWVzc2FnZSByZWNlaXZlZCBmcm9tIHdzXG4gICAqL1xuICBoYW5kbGVNZXNzYWdlKG1zZykge1xuICAgIGlmIChtc2cuZGF0YSA9PT0gXCJwaW5nXCIpIHJldHVybiB0aGlzLl9oYW5kbGVQaW5nKClcblxuICAgIGxldCBwYXJzZWRfbXNnID0gSlNPTi5wYXJzZShtc2cuZGF0YSlcbiAgICB0aGlzLmNoYW5uZWxzLmZvckVhY2goKGNoYW5uZWwpID0+IHtcbiAgICAgIGlmIChjaGFubmVsLnRvcGljID09PSBwYXJzZWRfbXNnLnRvcGljKSBjaGFubmVsLmhhbmRsZU1lc3NhZ2UocGFyc2VkX21zZylcbiAgICB9KVxuICB9XG59XG5cbm1vZHVsZS5leHBvcnRzID0ge1xuICBTb2NrZXQ6IFNvY2tldFxufVxuXG5cblxuLy8gV0VCUEFDSyBGT09URVIgLy9cbi8vIC4vbGliL2FtYmVyL2Fzc2V0cy9qcy9hbWJlci5qcyJdLCJzb3VyY2VSb290IjoiIn0=