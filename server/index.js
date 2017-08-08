const Koa = require('koa')
const ejs = require('ejs')
const fs = require('fs')
const path = require('path')
const app = new Koa()


const devTplPath =  path.resolve(__dirname, 'dev.tpl')
const prodTplPath =  path.resolve(__dirname, 'prod.tpl')

const defaultParams = {
	module: '',
	port: 8003,
	server_name: 'localhost',
	user: 'work'
}

app.use(async (ctx, next) => {
  const params = ctx.request.query
  const args = Object.assign({}, defaultParams, params)
  ctx.body = await renderTpl(args)
});

function readTpl() {
	return new Promise((resolve, reject) => {
		fs.readFile(devTplPath, {encoding: 'utf-8'}, (err, data) => {
		  if (err) throw err;
		  resolve(data)
		});
	})
}

function renderTpl(args) {
	return new Promise((resolve, reject) => {
		ejs.renderFile(devTplPath, {params: args}, {}, function(err, str){
		    if (err) throw err;
		    resolve(str)
		});
	})
}

app.listen(3000, '0.0.0.0');