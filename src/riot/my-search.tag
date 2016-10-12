<my-search>
  <form onsubmit={ search }>
    <input name="input" onkeyup={ edit }>
    <button disabled={ !text }>Search</button>
  </form>

  <script>
    this.disabled = true
    var self = this

    function edit(e){
      this.text = e.target.value ;
    }

    function search(text){
      fetch("http://example/com/api/string/" + text)
        .then(data => { return data.json()})
        .then(json => { self.update()})
    }
  </script>
</my-search>
