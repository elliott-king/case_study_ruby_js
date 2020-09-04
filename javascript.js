const entities = {
  fund: {
      1: { id: 1, name: 'VCPT Ventures III' },
      2: { id: 2, name: 'Huron Oak Equity V' },
      3: { id: 3, name: 'Pacific Capital Partners I' },
  },
  company: {
      15: { id: 15, name: 'FidoFarm', fund_id: 2, exited: false },
      23: { id: 23, name: 'Accumentor', fund_id: 2, exited: true },
      52: { id: 52, name: 'Dronez', fund_id: 1, exited: true },
      63: { id: 63, name: 'CoffeeBuilders', fund_id: 3, exited: false },
  },
}

// Referring to the javascript object above, please write functions or a utility class that will: 

// Return an array of fund objects in alphabetical order.
// Return an array of companies that belong to fund 2.
// Return an array of fund names with an exited company.


const prompt1 = () => {
  const arr = Object.values(entities.fund)
  return arr.sort((a,b) => a.name.localeCompare(b.name))
}

const prompt2 = () => {
  const arr = Object.values(entities.company)
  return arr.filter(a => a.fund_id === 2)
}

// Could be done in less lines, but I felt this is more readable.
// Time complexity is the O(f + c) regardless. 
const prompt3 = () => {

  // Make a copy so we do not mutate the original
  const funds = {...entities.fund}
  Object.values(funds).forEach(f => f.exited = false)

  // They already default to exited=false, so we need to check 
  // for any that did exit
  Object.values(entities.company).forEach(c => {
    if (c.exited) funds[c.fund_id].exited = true
  })

  let arr = Object.values(funds)
  arr = arr.filter(f => f.exited)
  return arr.map(f => f.name)
}
