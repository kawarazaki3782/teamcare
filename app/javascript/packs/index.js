import Vue from 'vue'

// 作成したコンポーネントファイルをimportします
import MicropostFavoriteButton from '../components/Favorite/MicropostFavoriteButton.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#micropost_favorite_button',
    components: { MicropostFavoriteButton }
  })
})