<my-search>
  <form onsubmit='{submit}'>
    <input type="text" name="searched_text">
    <button type="submit" name="submit" disabled={ !searched_text }>Search</button>
  </form>

  <script>
    var self = this
    this.submit = function(){
      console.log(this.searched_text.value)
      fetch(`http://localhost:5000/string/${this.searched_text.value}/samples?n_limit=10`)
        .then((response) => response.json())
        .then((json) => {
          console.log(json.sample_list);
        })
    }
  </script>
</my-search>
