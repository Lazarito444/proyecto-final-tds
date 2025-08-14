export const formatNumber = (number: number) => {
    return number.toLocaleString('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    })
}

export const formatDate=()=>{
    const date=new Date()
const day=date.getDate()
const month=date.getMonth()+1

const year=date.getFullYear()

const fecha=`${month}-${day}-${year}`

return fecha
}