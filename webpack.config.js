const path = require('path');
const CopyPlugin = require('copy-webpack-plugin');
const DevMode = process.env.NODE_ENV !== 'production';
const HTMLInlineCSSWebpackPlugin = require('html-inline-css-webpack-plugin').default;
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
  entry: './css/main.css',
  output: {
    filename: '[name].[contenthash].js',
    publicPath: '',
    path: path.resolve(process.cwd(), 'dist'),
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          { loader: MiniCssExtractPlugin.loader, options: {} },
          { loader: 'css-loader', options: { importLoaders: 1 } },
          'postcss-loader',
        ],
      },
      {
        test: /\.(woff(2)?|ttf|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]',
              outputPath: 'fonts/',
            },
          },
        ],
      },
    ],
  },
  optimization: {
    minimize: true,
    minimizer: [new CssMinimizerPlugin()],
  },
  plugins: [
    new CleanWebpackPlugin(),
    new CopyPlugin({
      patterns: [{ from: './robots.txt' }, { from: './images' }],
    }),
    new MiniCssExtractPlugin({ filename: DevMode ? '[name].css' : '[name].[contenthash].css' }),
    new HtmlWebpackPlugin({
      template: './index.html',
      filename: 'index.html',

      // parameters to pass to template
      commitRef: (process.env.COMMIT_REF ? process.env.COMMIT_REF : ''),
      commitRefShort: (process.env.COMMIT_REF ? process.env.COMMIT_REF.substring(0,7) : '')
    }),
    new HTMLInlineCSSWebpackPlugin(),
  ],
};
